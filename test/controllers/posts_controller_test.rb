require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @topic = @post.topic
    @user = @post.user
  end

  test "should get index" do
    sign_in @user

    get topic_posts_url(@topic)
    assert_response :success
  end

  test "should get new" do
    sign_in @user

    get new_topic_post_url(@topic)
    assert_response :success
  end

  test "should create post" do
    sign_in @user

    assert_difference("Post.count") do
      post topic_posts_url(@topic), params: { post: { content: @post.content, title: @post.title, topic_id: @post.topic_id } }
    end

    assert_redirected_to topic_post_url(@topic, Post.last)
  end

  test "should show post" do
    sign_in @user

    get topic_post_url(@topic, @post)
    assert_response :success
  end

  test "should get edit" do
    sign_in @user

    get edit_topic_post_url(@topic, @post)
    assert_response :success
  end

  test "should update post" do
    sign_in @user

    patch topic_post_url(@topic, @post), params: { post: { content: @post.content, title: @post.title } }
    assert_redirected_to topic_post_url(@topic, @post)
  end

  test "should destroy post" do
    sign_in @user

    assert_difference("Post.count", -1) do
      delete topic_post_url(@topic, @post)
    end

    assert_redirected_to topic_posts_url(@topic)
  end
end
