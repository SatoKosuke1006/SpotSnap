# frozen_string_literal: true

require 'test_helper'

class LikesInterface < ActionDispatch::IntegrationTest
  # 設定
  def setup
    @user = users(:michael)
    @micropost = microposts(:zone)
    @liked_micropost = microposts(:ants)
    log_in_as(@user)
  end
end

class LikePageTest < LikesInterface
  # いいね欄を表示する
  test 'like page' do
    get likes_path
    assert_response :success
    assert_not @user.likes.empty?
    assert_match @user.likes.count.to_s, response.body
    @user.likes.each do |like|
      assert_select 'a[href=?]', micropost_path(like.micropost)
    end
  end
end

class LikeInterfaceTest < LikesInterface
  # いいねする
  test 'should like the standard way' do
    assert_difference '@user.likes.count', 1 do
      post micropost_likes_path(@micropost), 
           params: { micropost_id: @micropost.id },
           headers: { 'Accept' => 'text/vnd.turbo-stream.html' }
    end
    assert_response :ok
    assert_match /turbo-stream action="update"/, response.body
  end

  # いいねを解除する
  test 'should unlike the standard way' do
    assert_difference '@user.likes.count', -1 do
      delete micropost_likes_path(@liked_micropost),
             headers: { 'Accept' => 'text/vnd.turbo-stream.html' }
    end
    assert_response :ok
    assert_match /turbo-stream action="update"/, response.body
  end
end