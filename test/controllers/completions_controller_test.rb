require "test_helper"

class CompletionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @habit = habits(:reading)
    sign_in_as(@user)
  end

  test "should create completion" do
    future_date = Date.current + 1.year
    assert_difference("HabitCompletion.count") do
      post habit_completions_url(@habit), params: {
        date: future_date.to_s,
        status: "completed"
      }
    end

    assert_response :redirect
    completion = @habit.completions.find_by(completed_on: future_date)
    assert_not_nil completion
    assert completion.completed?
  end

  test "should create skipped completion" do
    future_date = Date.current + 2.years
    post habit_completions_url(@habit), params: {
      date: future_date.to_s,
      status: "skipped"
    }

    completion = @habit.completions.find_by(completed_on: future_date)
    assert_not_nil completion
    assert completion.skipped?
  end

  test "should update existing completion" do
    existing_date = Date.current - 1.day
    existing = @habit.completions.find_by(completed_on: existing_date)
    assert existing.completed?

    assert_no_difference("HabitCompletion.count") do
      post habit_completions_url(@habit), params: {
        date: existing_date.to_s,
        status: "skipped"
      }
    end

    existing.reload
    assert existing.skipped?
  end

  test "should respond with turbo stream" do
    future_date = Date.current + 3.years
    post habit_completions_url(@habit), params: {
      date: future_date.to_s,
      status: "completed"
    }, headers: {"Accept" => "text/vnd.turbo-stream.html"}

    assert_response :success
    assert_match "turbo-stream", response.body
  end

  test "should destroy completion" do
    date = Date.current - 1.day
    assert @habit.completions.exists?(completed_on: date)

    delete habit_completions_url(@habit), params: {date: date.to_s}

    assert_not @habit.completions.exists?(completed_on: date)
  end

  test "should not access other user habit completions" do
    other_habit = habits(:other_user_habit)
    future_date = Date.current + 4.years

    post habit_completions_url(other_habit), params: {
      date: future_date.to_s,
      status: "completed"
    }
    assert_response :not_found
  end

  test "redirects to login when not authenticated" do
    sign_out
    post habit_completions_url(@habit), params: {
      date: Date.current.to_s,
      status: "completed"
    }
    assert_redirected_to new_session_url
  end
end
