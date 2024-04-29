# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # 設定
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  # 新規登録画面に遷移する
  test 'should get new' do
    get signup_path
    assert_response :success
  end

  # ログインしていない状態ではユーザー一覧画面に遷移できず、ログイン画面に遷移する
  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  # ログインしていない状態ではユーザー情報を編集できず、ログイン画面に遷移する
  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # ログインしていない状態ではユーザー情報を更新できず、ログイン画面に遷移する
  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # ユーザー本人でなければユーザー情報を編集できず、ログイン画面に遷移する
  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  # ユーザー本人でなければユーザー情報を更新できず、ログイン画面に遷移する
  test 'should redirect update when logged in as wrong user' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  # ログインしていない状態ではユーザー情報を削除できず、ログイン画面に遷移する
  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  # 管理者でないユーザーがユーザー情報を削除しようとすると、ホーム画面に遷移する
  test 'should redirect destroy when logged in as a non-admin' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end

  # ログインしていない状態ではフォロー中のユーザー一覧画面に遷移できず、ログイン画面に遷移する
  test 'should redirect following when not logged in' do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  # ログインしていない状態ではフォロワーのユーザー一覧画面に遷移できず、ログイン画面に遷移する
  test 'should redirect followers when not logged in' do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end