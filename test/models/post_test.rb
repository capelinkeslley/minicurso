require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "the truth" do
    post = posts(:one)
    assert post.valid?
  end

  test "should not be valid without title" do
    post = posts(:one)
    post.title = nil

    assert_not post.valid?
  end

  test "should not be valid without topic" do
    post = posts(:one)
    post.topic = nil

    assert_not post.valid?
  end
end
