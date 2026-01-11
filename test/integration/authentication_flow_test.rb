require "test_helper"

class AuthenticationFlowTest < ActionDispatch::IntegrationTest
  test "full registration and authentication flow" do
    # Visit registration page
    get new_registration_url
    assert_response :success

    # Register a new user
    post registration_url, params: {
      user: {
        email_address: "flowtest@example.com",
        password: "securepassword",
        password_confirmation: "securepassword"
      }
    }
    assert_redirected_to root_url
    follow_redirect!

    # Should be logged in and able to access habits
    get habits_url
    assert_response :success

    # Sign out
    delete session_url
    assert_redirected_to new_session_url

    # Should not be able to access habits anymore
    get habits_url
    assert_redirected_to new_session_url

    # Sign back in
    post session_url, params: {
      email_address: "flowtest@example.com",
      password: "securepassword"
    }
    assert_response :redirect
    follow_redirect!

    # Should be logged in again
    get habits_url
    assert_response :success
  end

  test "login with invalid credentials" do
    get new_session_url
    assert_response :success

    post session_url, params: {
      email_address: "nonexistent@example.com",
      password: "wrongpassword"
    }

    assert_redirected_to new_session_url
  end

  test "protected routes redirect to login" do
    protected_routes = [
      habits_url,
      new_habit_url,
      archived_habits_url,
      statistics_url
    ]

    protected_routes.each do |route|
      get route
      assert_redirected_to new_session_url, "Expected #{route} to redirect to login"
    end
  end
end
