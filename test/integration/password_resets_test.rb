# frozen_string_literal: true

require 'test_helper'

class PasswordResets < ActionDispatch::IntegrationTest
  # 設定
  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class ForgotPasswordFormTest < PasswordResets
  # パスワードリセットのパスが正しい
  test 'password reset path' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
  end

  # 無効なメールアドレスだとパスワードをリセットできない
  test 'reset path with invalid email' do
    post password_resets_path, params: { password_reset: { email: '' } }
    assert_response :unprocessable_entity
    assert_not flash.empty?
    assert_template 'password_resets/new'
  end
end

class PasswordResetForm < PasswordResets
  # 設定
  def setup
    super
    @user = users(:michael)
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    @reset_user = assigns(:user)
  end
end

class PasswordFormTest < PasswordResetForm
  # パスワードリセットのメールが送信される
  test 'reset with valid email' do
    assert_not_equal @user.reset_digest, @reset_user.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  # 存在しないメールアドレスだとパスワードをリセットできない
  test 'reset with wrong email' do
    get edit_password_reset_path(@reset_user.reset_token, email: "")
    assert_redirected_to root_url
  end

  # 有効化されていないユーザーはパスワードをリセットできない
  test 'reset with inactive user' do
    @reset_user.toggle!(:activated)
    get edit_password_reset_path(@reset_user.reset_token,
                                 email: @reset_user.email)
    assert_redirected_to root_url
  end

  # メールアドレスは正しいがトークンが間違っているとパスワードをリセットできない
  test 'reset with right email but wrong token' do
    get edit_password_reset_path('wrong token', email: @reset_user.email)
    assert_redirected_to root_url
  end

  # メールアドレスもトークンも正しいときだけパスワードをリセットできる
  test 'reset with right email and right token' do
    get edit_password_reset_path(@reset_user.reset_token,
                                 email: @reset_user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', @reset_user.email
  end
end

class PasswordUpdateTest < PasswordResetForm
  # 無効なパスワードだとエラーが表示される
  test 'update with invalid password and confirmation' do
    patch password_reset_path(@reset_user.reset_token),
          params: { email: @reset_user.email,
                    user: { password: 'foobaz',
                            password_confirmation: 'barquux' } }
    assert_select 'div.login-error-message'
  end

  # パスワードが空だとエラーが表示される
  test 'update with empty password' do
    patch password_reset_path(@reset_user.reset_token),
          params: { email: @reset_user.email,
                    user: { password: '',
                            password_confirmation: '' } }
    assert_select 'div.login-error-message'
  end

  # パスワードが有効だとパスワードがリセットされる
  test 'update with valid password and confirmation' do
    patch password_reset_path(@reset_user.reset_token),
          params: { email: @reset_user.email,
                    user: { password: 'foobaz',
                            password_confirmation: 'foobaz' } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to @reset_user
  end
end
