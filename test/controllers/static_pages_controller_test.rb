# frozen_string_literal: true

require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  # ホーム画面を表示する
  test 'should get home' do
    get root_path
    assert_response :success
    assert_select 'title', 'SpotSnap'
  end
end
