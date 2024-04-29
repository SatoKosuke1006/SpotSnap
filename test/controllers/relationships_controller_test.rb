# frozen_string_literal: true

require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  # リレーションシップを作成し、ログイン画面に遷移する
  test 'create should require logged-in user' do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  # リレーションシップを削除し、ログイン画面に遷移する
  test 'destroy should require logged-in user' do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end
end
