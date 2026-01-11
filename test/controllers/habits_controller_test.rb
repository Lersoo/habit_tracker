require "test_helper"

class HabitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @habit = habits(:exercise)
    sign_in_as(@user)
  end

  test "should get index" do
    get habits_url
    assert_response :success
    assert_select "h1", I18n.t("habits.index.title")
  end

  test "should get archived" do
    get archived_habits_url
    assert_response :success
    assert_select "h1", I18n.t("habits.archived.title")
  end

  test "should get new" do
    get new_habit_url
    assert_response :success
    assert_select "h1", I18n.t("habits.new.title")
  end

  test "should create habit" do
    assert_difference("Habit.count") do
      post habits_url, params: {
        habit: {
          name: "New Habit",
          description: "Test description",
          frequency: "daily",
          color: "#ffffff"
        }
      }
    end

    assert_redirected_to habits_url
  end

  test "should not create invalid habit" do
    assert_no_difference("Habit.count") do
      post habits_url, params: {
        habit: {
          name: "",
          frequency: "daily",
          color: "#ffffff"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should show habit" do
    get habit_url(@habit)
    assert_response :success
    assert_select "h1", @habit.name
  end

  test "should get edit" do
    get edit_habit_url(@habit)
    assert_response :success
    assert_select "h1", I18n.t("habits.edit.title")
  end

  test "should update habit" do
    patch habit_url(@habit), params: {
      habit: {
        name: "Updated Name"
      }
    }

    assert_redirected_to habits_url
    @habit.reload
    assert_equal "Updated Name", @habit.name
  end

  test "should not update with invalid params" do
    patch habit_url(@habit), params: {
      habit: {
        name: ""
      }
    }

    assert_response :unprocessable_entity
  end

  test "should destroy habit" do
    assert_difference("Habit.count", -1) do
      delete habit_url(@habit)
    end

    assert_redirected_to habits_url
  end

  test "should archive habit" do
    patch archive_habit_url(@habit)

    assert_redirected_to habits_url
    @habit.reload
    assert @habit.archived?
  end

  test "should unarchive habit" do
    archived = habits(:archived_habit)
    patch unarchive_habit_url(archived)

    assert_redirected_to habits_url
    archived.reload
    assert_not archived.archived?
  end

  test "should not access other user habits" do
    other_habit = habits(:other_user_habit)
    get habit_url(other_habit)
    assert_response :not_found
  end

  test "redirects to login when not authenticated" do
    sign_out
    get habits_url
    assert_redirected_to new_session_url
  end
end
