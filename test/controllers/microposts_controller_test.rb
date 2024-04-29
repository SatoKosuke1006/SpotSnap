# frozen_string_literal: true

require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  # 投稿を作成する
  def setup
    @micropost = microposts(:orange)
  end

  # ログインしていない状態では投稿できず、ログイン画面に遷移する
  test 'should redirect create when not logged in' do
    assert_no_difference 'Micropost.count' do
      post microposts_path
    end
    assert_redirected_to login_url
  end

  # ログインしていない状態では投稿を削除できず、ログイン画面に遷移する
  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  # 投稿者でないユーザーが投稿を削除しようとすると、ホーム画面に遷移する
  test 'should redirect destroy for wrong micropost' do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end
end
