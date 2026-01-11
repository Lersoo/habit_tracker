require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_registration_url
    assert_response :success
    assert_select "h1", I18n.t("registrations.new.title")
  end

  test "should create user" do
    assert_difference("User.count") do
      post registration_url, params: {
        user: {
          email_address: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_url
  end

  test "should not create user with mismatched passwords" do
    assert_no_difference("User.count") do
      post registration_url, params: {
        user: {
          email_address: "uniqueuser@example.com",
          password: "password123",
          password_confirmation: "different"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "signs in user after registration" do
    post registration_url, params: {
      user: {
        email_address: "newuser2@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }

    assert_redirected_to root_url
    follow_redirect!

    get habits_url
    assert_response :success
  end
end
