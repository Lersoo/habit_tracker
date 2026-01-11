require "test_helper"

class HabitCompletionTest < ActiveSupport::TestCase
  setup do
    @habit = habits(:exercise)
  end

  test "valid completion" do
    completion = HabitCompletion.new(
      habit: @habit,
      completed_on: Date.current + 1.year,
      status: :completed
    )
    assert completion.valid?
  end

  test "invalid without completed_on" do
    completion = HabitCompletion.new(habit: @habit, status: :completed)
    assert_not completion.valid?
    assert_includes completion.errors[:completed_on], "can't be blank"
  end

  test "status defaults to completed" do
    completion = HabitCompletion.new(habit: @habit, completed_on: Date.current + 1.year)
    assert completion.valid?
    assert_equal "completed", completion.status
  end

  test "invalid with duplicate date for same habit" do
    completion = HabitCompletion.new(
      habit: @habit,
      completed_on: Date.current,
      status: :completed
    )
    assert_not completion.valid?
    assert_includes completion.errors[:completed_on], "has already been taken"
  end

  test "allows same date for different habits" do
    other_habit = habits(:reading)
    completion = HabitCompletion.new(
      habit: other_habit,
      completed_on: Date.current,
      status: :completed
    )
    assert completion.valid?
  end

  test "belongs to habit" do
    completion = habit_completions(:exercise_today)
    assert_respond_to completion, :habit
    assert_equal @habit, completion.habit
  end

  test "status enum values" do
    assert_equal 0, HabitCompletion.statuses[:completed]
    assert_equal 1, HabitCompletion.statuses[:skipped]
  end

  test "on_date scope filters by date" do
    completions = HabitCompletion.on_date(Date.current)
    completions.each do |c|
      assert_equal Date.current, c.completed_on
    end
  end

  test "completed_only scope filters by status" do
    completions = HabitCompletion.completed_only
    completions.each do |c|
      assert c.completed?
    end
  end

  test "completed? returns true for completed status" do
    completion = habit_completions(:exercise_today)
    assert completion.completed?
    assert_not completion.skipped?
  end

  test "skipped? returns true for skipped status" do
    completion = habit_completions(:meditation_today)
    assert completion.skipped?
    assert_not completion.completed?
  end
end
