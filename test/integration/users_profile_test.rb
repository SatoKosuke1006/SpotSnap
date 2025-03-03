# frozen_string_literal: true

require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  # 設定
  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  # プロフィール画面の表示
  test 'profile display' do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'div.profile-name', text: @user.name
    assert_match @user.microposts.count.to_s, response.body
  end
end
