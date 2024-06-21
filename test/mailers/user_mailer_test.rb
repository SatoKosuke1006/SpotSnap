# frozen_string_literal: true

require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # アカウント有効化メールの送信
  test 'account_activation' do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal 'アカウントの有効化', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['support@spotsnap.net'], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

  # パスワードリセットメールの送信
  test 'password_reset' do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal 'パスワードの変更', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['support@spotsnap.net'], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end
end
