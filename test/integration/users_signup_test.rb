# frozen_string_literal: true

require 'test_helper'

class UsersSignup < ActionDispatch::IntegrationTest
  # 設定
  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class UsersSignupTest < UsersSignup
  # 無効な情報で登録しようとすると、エラーメッセージが表示される
  test 'invalid signup information' do
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
    assert_select 'div.error-message'
    assert_select 'div.field_with_errors'
  end

  # 有効な情報で登録し、アカウントを有効化する
  test 'valid signup information with account activation' do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end

class AccountActivationTest < UsersSignup
  # 設定
  def setup
    super
    post users_path, params: { user: { name: 'Example User',
                                       email: 'user@example.com',
                                       password: 'password',
                                       password_confirmation: 'password' } }
    @user = assigns(:user)
  end

  # 有効化されていない
  test 'should not be activated' do
    assert_not @user.activated?
  end

  # 有効化されていない状態でログインしようとすると、ログインできない
  test 'should not be able to log in before account activation' do
    log_in_as(@user)
    assert_not is_logged_in?
  end

  # 有効化トークンが不正な場合、ログインできない
  test 'should not be able to log in with invalid activation token' do
    get edit_account_activation_path('invalid token', email: @user.email)
    assert_not is_logged_in?
  end

  # メールアドレスが不正な場合、ログインできない
  test 'should not be able to log in with invalid email' do
    get edit_account_activation_path(@user.activation_token, email: 'wrong')
    assert_not is_logged_in?
  end

  # 有効化されたアカウントでログインできる
  test 'should log in successfully with valid activation token and email' do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    assert @user.reload.activated?
    follow_redirect!
    assert_template 'static_pages/home'
    assert is_logged_in?
  end
end
