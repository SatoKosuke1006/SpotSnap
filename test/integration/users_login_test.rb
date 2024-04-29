# frozen_string_literal: true

require 'test_helper'

class UsersLogin < ActionDispatch::IntegrationTest
  # 設定
  def setup
    @user = users(:michael)
  end
end

class InvalidPasswordTest < UsersLogin
  # ログイン画面に遷移する
  test 'login path' do
    get login_path
    assert_template 'sessions/new'
  end

  # パスワードが空だとログインできない
  test 'login with valid email/invalid password' do
    post login_path, params: { session: { email: @user.email,
                                          password: 'invalid' } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end

class ValidLogin < UsersLogin
  # 設定
  def setup
    super
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
  end
end

class ValidLoginTest < ValidLogin
  # ログインしたら、ホーム画面に遷移する
  test 'valid login' do
    assert is_logged_in?
    assert_redirected_to home_path
  end

  # ログイン後に表示リンクが変わる
  test 'redirect after login' do
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
  end
end

class Logout < ValidLogin
  # 設定
  def setup
    super
    delete logout_path
  end
end

class LogoutTest < Logout
  # ログアウトしたら、ログイン画面に遷移する
  test 'successful logout' do
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
  end

  # ログアウト後の挙動が正しい
  test 'should still work after logout in second window' do
    delete logout_path
    assert_redirected_to root_url
  end
end

class RememberingTest < UsersLogin
  # ログインすると記憶トークンが設定される
  test 'login with remembering' do
    log_in_as(@user, remember_me: '1')
    assert_not cookies[:remember_token].blank?
  end

  # ログアウトすると記憶トークンが削除される
  test 'login without remembering' do
    # Cookieを保存してログイン
    log_in_as(@user, remember_me: '1')
    # Cookieが削除されていることを検証してからログイン
    log_in_as(@user, remember_me: '0')
    assert cookies[:remember_token].blank?
  end
end
