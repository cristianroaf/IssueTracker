require 'test_helper'

class WatchersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @watcher = watchers(:one)
  end

  test "should get index" do
    get watchers_url
    assert_response :success
  end

  test "should get new" do
    get new_watcher_url
    assert_response :success
  end

  test "should create watcher" do
    assert_difference('Watcher.count') do
      post watchers_url, params: { watcher: { issue_id: @watcher.issue_id, user_id: @watcher.user_id } }
    end

    assert_redirected_to watcher_url(Watcher.last)
  end

  test "should show watcher" do
    get watcher_url(@watcher)
    assert_response :success
  end

  test "should get edit" do
    get edit_watcher_url(@watcher)
    assert_response :success
  end

  test "should update watcher" do
    patch watcher_url(@watcher), params: { watcher: { issue_id: @watcher.issue_id, user_id: @watcher.user_id } }
    assert_redirected_to watcher_url(@watcher)
  end

  test "should destroy watcher" do
    assert_difference('Watcher.count', -1) do
      delete watcher_url(@watcher)
    end

    assert_redirected_to watchers_url
  end
end
