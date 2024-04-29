# frozen_string_literal: true

require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  # 設定
  def setup
    @like = Like.new(user_id: users(:michael).id, micropost_id: microposts(:orange).id)
  end

  # いいね関係が有効である
  test 'should be valid' do
    assert @like.valid?
  end

  # ユーザーIDが存在する
  test 'should require a user_id' do
    @like.user_id = nil
    assert_not @like.valid?
  end

  # マイクロポストIDが存在する
  test 'should require a micropost_id' do
    @like.micropost_id = nil
    assert_not @like.valid?
  end
end
