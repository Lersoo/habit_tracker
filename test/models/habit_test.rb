require "test_helper"

class HabitTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @habit = habits(:exercise)
  end

  test "valid habit" do
    habit = Habit.new(user: @user, name: "Test Habit", frequency: :daily, color: "#ffffff")
    assert habit.valid?
  end

  test "invalid without name" do
    habit = Habit.new(user: @user, frequency: :daily, color: "#ffffff")
    assert_not habit.valid?
    assert_includes habit.errors[:name], "can't be blank"
  end

  test "frequency defaults to daily" do
    habit = Habit.new(user: @user, name: "Test", color: "#ffffff")
    assert habit.valid?
    assert_equal "daily", habit.frequency
  end

  test "color defaults to blue" do
    habit = Habit.new(user: @user, name: "Test", frequency: :daily)
    assert habit.valid?
    assert_equal "#3b82f6", habit.color
  end

  test "belongs to user" do
    assert_respond_to @habit, :user
    assert_equal @user, @habit.user
  end

  test "has many completions" do
    assert_respond_to @habit, :completions
  end

  test "active scope excludes archived habits" do
    active_habits = Habit.active
    assert_not_includes active_habits, habits(:archived_habit)
    assert_includes active_habits, @habit
  end

  test "archived scope includes only archived habits" do
    archived_habits = Habit.archived
    assert_includes archived_habits, habits(:archived_habit)
    assert_not_includes archived_habits, @habit
  end

  test "completion_for returns completion for given date" do
    completion = @habit.completion_for(Date.current)
    assert_not_nil completion
    assert_equal Date.current, completion.completed_on
  end

  test "completion_for returns nil when no completion exists" do
    completion = @habit.completion_for(Date.current - 1.year)
    assert_nil completion
  end

  test "completed_on? returns true when completed" do
    assert @habit.completed_on?(Date.current)
  end

  test "completed_on? returns false when not completed" do
    assert_not @habit.completed_on?(Date.current - 1.year)
  end

  test "skipped_on? returns true when skipped" do
    meditation = habits(:meditation)
    assert meditation.skipped_on?(Date.current)
  end

  test "current_streak counts consecutive completed days" do
    assert_equal 3, @habit.current_streak
  end

  test "current_streak returns 0 when no completions" do
    habit = Habit.create!(user: @user, name: "New Habit", frequency: :daily, color: "#ffffff")
    assert_equal 0, habit.current_streak
  end

  test "longest_streak calculates correctly" do
    assert_equal 3, @habit.longest_streak
  end

  test "longest_streak returns 0 when no completions" do
    habit = Habit.create!(user: @user, name: "New Habit", frequency: :daily, color: "#ffffff")
    assert_equal 0, habit.longest_streak
  end

  test "completion_rate calculates percentage" do
    rate = @habit.completion_rate(days: 30)
    assert rate.is_a?(Integer)
    assert rate >= 0
    assert rate <= 100
  end

  test "total_completions counts only completed status" do
    assert_equal 3, @habit.total_completions
  end

  test "destroys associated completions when destroyed" do
    habit = Habit.create!(user: @user, name: "To Delete", frequency: :daily, color: "#ffffff")
    habit.completions.create!(completed_on: Date.current, status: :completed)
    completion_id = habit.completions.first.id

    habit.destroy
    assert_nil HabitCompletion.find_by(id: completion_id)
  end

  test "frequency enum values" do
    assert_equal 0, Habit.frequencies[:daily]
    assert_equal 1, Habit.frequencies[:weekdays]
    assert_equal 2, Habit.frequencies[:weekends]
    assert_equal 3, Habit.frequencies[:custom]
  end
end
