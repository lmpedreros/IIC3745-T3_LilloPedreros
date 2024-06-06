require 'test_helper'

class ContactMessageTest < ActiveSupport::TestCase
  test "should save contact message with valid attributes" do
    contact_message = ContactMessage.new(title: "Valid Title", body: "Valid body content", name: "Valid Name", mail: "valid@example.com", phone: "+56912345678")
    assert contact_message.valid?, "Contact message should be valid with correct attributes"
    assert contact_message.save, "Contact message should save successfully with correct attributes"
  end

  test "should not save contact message without title" do
    contact_message = ContactMessage.new(body: "Valid body content", name: "Valid Name", mail: "valid@example.com", phone: "+56912345678")
    assert_not contact_message.valid?, "Contact message should be invalid without title"
    assert contact_message.errors[:title].any?, "No validation error for 'title' present"
  end

  test "should not save contact message with long title" do
    contact_message = ContactMessage.new(title: "a" * 51, body: "Valid body content", name: "Valid Name", mail: "valid@example.com", phone: "+56912345678")
    assert_not contact_message.valid?, "Contact message should be invalid with title longer than 50 characters"
    assert contact_message.errors[:title].any?, "No validation error for 'title' present"
  end

  test "should not save contact message without body" do
    contact_message = ContactMessage.new(title: "Valid Title", name: "Valid Name", mail: "valid@example.com", phone: "+56912345678")
    assert_not contact_message.valid?, "Contact message should be invalid without body"
    assert contact_message.errors[:body].any?, "No validation error for 'body' present"
  end

  test "should not save contact message with long body" do
    contact_message = ContactMessage.new(title: "Valid Title", body: "a" * 501, name: "Valid Name", mail: "valid@example.com", phone: "+56912345678")
    assert_not contact_message.valid?, "Contact message should be invalid with body longer than 500 characters"
    assert contact_message.errors[:body].any?, "No validation error for 'body' present"
  end

  test "should not save contact message without name" do
    contact_message = ContactMessage.new(title: "Valid Title", body: "Valid body content", mail: "valid@example.com", phone: "+56912345678")
    assert_not contact_message.valid?, "Contact message should be invalid without name"
    assert contact_message.errors[:name].any?, "No validation error for 'name' present"
  end

  test "should not save contact message with long name" do
    contact_message = ContactMessage.new(title: "Valid Title", body: "Valid body content", name: "a" * 51, mail: "valid@example.com", phone: "+56912345678")
    assert_not contact_message.valid?, "Contact message should be invalid with name longer than 50 characters"
    assert contact_message.errors[:name].any?, "No validation error for 'name' present"
  end

  test "should not save contact message without mail" do
    contact_message = ContactMessage.new(title: "Valid Title", body: "Valid body content", name: "Valid Name", phone: "+56912345678")
    assert_not contact_message.valid?, "Contact message should be invalid without mail"
    assert contact_message.errors[:mail].any?, "No validation error for 'mail' present"
  end

  test "should not save contact message with invalid mail" do
    contact_message = ContactMessage.new(title: "Valid Title", body: "Valid body content", name: "Valid Name", mail: "invalid-email", phone: "+56912345678")
    assert_not contact_message.valid?, "Contact message should be invalid with invalid mail"
    assert contact_message.errors[:mail].any?, "No validation error for 'mail' present"
  end

  test "should not save contact message with long mail" do
    contact_message = ContactMessage.new(title: "Valid Title", body: "Valid body content", name: "Valid Name", mail: "a" * 51 + "@example.com", phone: "+56912345678")
    assert_not contact_message.valid?, "Contact message should be invalid with mail longer than 50 characters"
    assert contact_message.errors[:mail].any?, "No validation error for 'mail' present"
  end

  test "should save contact message without phone" do
    contact_message = ContactMessage.new(title: "Valid Title", body: "Valid body content", name: "Valid Name", mail: "valid@example.com")
    assert contact_message.valid?, "Contact message should be valid without phone"
    assert contact_message.save, "Contact message should save successfully without phone"
  end

  test "should not save contact message with invalid phone" do
    contact_message = ContactMessage.new(title: "Valid Title", body: "Valid body content", name: "Valid Name", mail: "valid@example.com", phone: "+569123456")
    assert_not contact_message.valid?, "Contact message should be invalid with invalid phone format"
    assert contact_message.errors[:phone].any?, "No validation error for 'phone' present"
  end
end