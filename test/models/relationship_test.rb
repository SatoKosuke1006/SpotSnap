# frozen_string_literal: true

require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  # 設定
  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id, followed_id: users(:archer).id)
  end

  # フォロー関係が有効である
  test 'should be valid' do
    assert @relationship.valid?
  end

  # フォロワーIDが存在する
  test 'should require a follower_id' do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  # フォローIDが存在する
  test 'should require a followed_id' do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
