# frozen_string_literal: true

require 'test_helper'
include ActionDispatch::TestProcess # rubocop:disable Style/MixinUsage

class MicropostTest < ActiveSupport::TestCase
  # 設定
  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: 'Lorem ipsum', place_id: 'ChIJd8BlQ2BPhUcRt6B2K90aOZo')
  end

  # 投稿が有効である
  test 'should be valid' do
    file = fixture_file_upload('us.jpeg', 'image/jpeg')
    @micropost.image.attach(file)
    assert @micropost.valid?, @micropost.errors.full_messages.to_sentence
  end

  # 投稿にユーザーIDが存在する
  test 'user id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  # 投稿に画像が存在する
  test 'image should be present' do
    @micropost.image.purge
    assert_not @micropost.valid?
  end

  # 投稿に画像の形式が正しい
  test 'image content type should be valid' do
    file = fixture_file_upload('us.bmp', 'us/bmp')
    @micropost.image.attach(file)
    assert_not @micropost.valid?
  end

  # 投稿の長さを制限
  test 'content should be at most 140 characters' do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # 最新の投稿が最初に表示される
  test 'order should be most recent first' do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
