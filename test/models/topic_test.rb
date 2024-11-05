require "test_helper"

class TopicTest < ActiveSupport::TestCase
  test "the truth" do
    topic = topics(:one)
    assert topic.valid?
  end

  test "should not be valid without title" do
    topic = topics(:one)
    topic.title = nil

    assert_not topic.valid?
  end

  test "should not be valid without description" do
    topic = topics(:one)
    topic.description = nil

    assert_not topic.valid?
  end

  test "should not be valid without user" do
    topic = topics(:one)
    topic.user = nil

    assert_not topic.valid?
  end
end
