require "test_helper"

class StatisticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get statistics_url
    assert_response :success
    assert_select "h1", I18n.t("statistics.index.title")
  end

  test "displays total habits count" do
    get statistics_url
    assert_response :success
    assert_select "p", /#{@user.habits.active.count}/
  end

  test "displays current top streaks" do
    get statistics_url
    assert_response :success
  end

  test "shows empty state when no habits" do
    @user.habits.destroy_all
    get statistics_url
    assert_response :success
    assert_select "p", I18n.t("statistics.index.no_habits")
  end

  test "redirects to login when not authenticated" do
    sign_out
    get statistics_url
    assert_redirected_to new_session_url
  end
end
