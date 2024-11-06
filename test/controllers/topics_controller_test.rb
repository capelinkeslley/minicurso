require "test_helper"

class TopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @topic = topics(:one)
    @user = @topic.user
  end

  test "should get index" do
    sign_in @user

    get topics_url
    assert_response :success
  end

  test "should get new" do
    sign_in @user

    get new_topic_url
    assert_response :success
  end

  test "should create topic" do
    sign_in @user

    assert_difference("Topic.count") do
      post topics_url, params: { topic: { description: @topic.description, is_private: @topic.is_private, title: @topic.title, user_id: @topic.user_id } }
    end

    assert_redirected_to topic_url(Topic.last)
  end

  test "should show topic" do
    sign_in @user

    get topic_url(@topic)
    assert_response :success
  end

  test "should get edit" do
    sign_in @user

    get edit_topic_url(@topic)
    assert_response :success
  end

  test "should update topic" do
    sign_in @user

    patch topic_url(@topic), params: { topic: { description: @topic.description, is_private: @topic.is_private, title: @topic.title, user_id: @topic.user_id } }
    assert_redirected_to topic_url(@topic)
  end

  test "should destroy topic" do
    assert_difference("Topic.count", -1) do
      sign_in @user

      delete topic_url(@topic)
    end

    assert_redirected_to topics_url
  end
end
