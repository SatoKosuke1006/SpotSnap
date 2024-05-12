# frozen_string_literal: true

require 'test_helper'

class MicropostsInterface < ActionDispatch::IntegrationTest
  # 設定
  def setup
    @user = users(:michael)
    log_in_as(@user)
  end
end

class MicropostsInterfaceTest < MicropostsInterface

  # 無効な投稿であればエラーメッセージが表示され、投稿されない
  test 'should show errors but not create micropost on invalid submission' do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # assert_select 'a[href=?]', '/?page=2'
  end

  # 有効な投稿であれば投稿される
  test 'should create a micropost on valid submission' do
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { 
        content: 'Lorem ipsum',
        image: fixture_file_upload('us.jpeg', 'image/jpeg'),
        lat: 123.456,
        lng: 78.910,
        place_id: 'ChIJd8BlQ2BPhUcRt6B2K90aOZo'
      } }
    end
    assert_redirected_to home_url
    follow_redirect!
  end

  # 投稿が削除される
  test 'should be able to delete own micropost' do
    first_micropost = @user.microposts.first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
  end

  # 他人の投稿には削除リンクがない
  test "should not have delete links on other user's profile page" do
    get user_path(users(:archer))
    assert_select 'a', { text: 'delete', count: 0 }
  end
end
