# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  # ログイン画面を表示する
  test 'should get new' do
    get login_path
    assert_response :success
  end
end
