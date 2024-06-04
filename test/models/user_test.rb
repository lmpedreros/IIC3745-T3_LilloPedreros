require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Test User", email: "user@test.com", password: "password")
  end

  # Happy path test
  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  # Alternative path tests for validations
  test "should be invalid without a name" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "should be invalid if name is too short" do
    @user.name = "A"
    assert_not @user.valid?
  end

  test "should be invalid if name is too long" do
    @user.name = "A" * 26
    assert_not @user.valid?
  end

  test "should be invalid without an email" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "should be invalid with a duplicate email" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
end
