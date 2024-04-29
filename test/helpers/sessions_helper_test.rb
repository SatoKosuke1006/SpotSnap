# frozen_string_literal: true

require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  # 設定
  def setup
    @user = users(:michael)
    remember(@user)
  end

  # ログインしている場合に正しいユーザーを返す
  test 'current_user returns right user when session is nil' do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  # ログインしていない場合にnilを返す
  test 'current_user returns nil when remember digest is wrong' do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
