require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(email_address: "test@example.com", password: "password123")
    assert user.valid?
  end

  test "requires email_address for uniqueness" do
    existing_user = users(:one)
    user = User.new(email_address: existing_user.email_address, password: "password123")
    assert_not user.valid?
  end

  test "invalid without password" do
    user = User.new(email_address: "test@example.com")
    assert_not user.valid?
  end

  test "normalizes email to lowercase" do
    user = User.new(email_address: "TEST@EXAMPLE.COM", password: "password123")
    user.save
    assert_equal "test@example.com", user.email_address
  end

  test "strips whitespace from email" do
    user = User.new(email_address: "  test@example.com  ", password: "password123")
    user.save
    assert_equal "test@example.com", user.email_address
  end

  test "has many habits" do
    user = users(:one)
    assert_respond_to user, :habits
    assert user.habits.count > 0
  end

  test "has many sessions" do
    user = users(:one)
    assert_respond_to user, :sessions
  end

  test "destroys associated habits when destroyed" do
    user = users(:one)
    habit_count = user.habits.count
    assert habit_count > 0

    user.destroy
    assert_equal 0, Habit.where(user_id: user.id).count
  end
end
