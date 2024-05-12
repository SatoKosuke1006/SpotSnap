# frozen_string_literal: true
require 'test_helper'
include ActionDispatch::TestProcess # rubocop:disable Style/MixinUsage

class UserTest < ActiveSupport::TestCase
  # 設定
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'foobar', password_confirmation: 'foobar')
  end

  # ユーザーが有効である
  test 'should be valid' do
    assert @user.valid?
  end

  # ユーザー名が存在する
  test 'name should be present' do
    @user.name = '     '
    assert_not @user.valid?
  end

  # メールアドレスが存在する
  test 'email should be present' do
    @user.email = '     '
    assert_not @user.valid?
  end

  # ユーザー名の長さを制限
  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  # メールアドレスの長さを制限
  test 'email should not be too long' do
    @user.email = "#{'a' * 244}@example.com"
    assert_not @user.valid?
  end

  # 有効なメールアドレスのフォーマットを許可
  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  # 無効なメールアドレスのフォーマットを拒否
  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # メールアドレスが一意である
  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  # メールアドレスが小文字で保存される
  test 'email addresses should be saved as lowercase' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # パスワードが存在する
  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  # パスワードの長さを制限
  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  # 記憶ダイジェストが存在しない場合はfalseを返す
  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

  # ユーザーを削除すると関連する投稿も削除される
  test 'associated microposts should be destroyed' do
    @user.save
    file = fixture_file_upload('us.jpeg', 'image/jpeg')
    @user.microposts.create!(content: 'Lorem ipsum', image: file, lat: 123.456, lng: 78.910, place_id: 'ChIJd8BlQ2BPhUcRt6B2K90aOZo')
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  # ユーザーをフォロー、もしくはアンフォローする
  test 'should follow and unfollow a user' do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
    # ユーザーは自分自身をフォローできない
    michael.follow(michael)
    assert_not michael.following?(michael)
  end

  # 投稿の内容が正しい
  test 'feed should have the right posts' do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # フォロワーがいるユーザー自身の投稿を確認
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end
