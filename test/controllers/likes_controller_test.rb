# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  # 設定
  def setup
    @micropost = microposts(:orange)
  end

  # ログインしていない状態ではいいねできず、ログイン画面に遷移する
  test 'should redirect create when not logged in' do
    assert_no_difference 'Like.count' do
      post micropost_likes_path(@micropost), params: { micropost: @micropost }
    end
    assert_redirected_to login_url
  end

  # ログインしていない状態ではいいねを削除できず、ログイン画面に遷移する
  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Like.count' do
      delete micropost_likes_path(@micropost)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end
end
