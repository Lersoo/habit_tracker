require "test_helper"

class HabitWorkflowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  test "complete habit workflow: create, check-in, archive, delete" do
    # Create a new habit
    get new_habit_url
    assert_response :success

    post habits_url, params: {
      habit: {
        name: "Test Workflow Habit",
        description: "Testing the full workflow",
        frequency: "daily",
        color: "#ff0000"
      }
    }
    assert_redirected_to habits_url
    follow_redirect!

    habit = Habit.find_by(name: "Test Workflow Habit")
    assert_not_nil habit

    # Check in for today
    post habit_completions_url(habit), params: {
      date: Date.current.to_s,
      status: "completed"
    }
    assert_redirected_to habits_url

    assert habit.completed_on?(Date.current)
    assert_equal 1, habit.current_streak

    # View habit details
    get habit_url(habit)
    assert_response :success
    assert_select "h1", habit.name

    # Archive the habit
    patch archive_habit_url(habit)
    assert_redirected_to habits_url

    habit.reload
    assert habit.archived?

    # Verify it appears in archived list
    get archived_habits_url
    assert_response :success
    assert_select "h3", habit.name

    # Unarchive the habit
    patch unarchive_habit_url(habit)
    assert_redirected_to habits_url

    habit.reload
    assert_not habit.archived?

    # Delete the habit
    delete habit_url(habit)
    assert_redirected_to habits_url

    assert_nil Habit.find_by(id: habit.id)
  end

  test "streak tracking across multiple days" do
    habit = Habit.create!(
      user: @user,
      name: "Streak Test Habit",
      frequency: :daily,
      color: "#00ff00"
    )

    # Complete for three consecutive days
    [2, 1, 0].each do |days_ago|
      habit.completions.create!(
        completed_on: Date.current - days_ago.days,
        status: :completed
      )
    end

    assert_equal 3, habit.current_streak
    assert_equal 3, habit.longest_streak

    # Break the streak by skipping a day and completing today
    habit.completions.destroy_all
    habit.completions.create!(completed_on: Date.current - 2.days, status: :completed)
    habit.completions.create!(completed_on: Date.current, status: :completed)

    assert_equal 1, habit.current_streak
  end

  test "viewing statistics after completing habits" do
    get statistics_url
    assert_response :success

    # Should show the user's active habits
    assert_select "h1", I18n.t("statistics.index.title")
  end
end
