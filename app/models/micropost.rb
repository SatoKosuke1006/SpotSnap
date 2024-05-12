# frozen_string_literal: true

# Micropost
class Micropost < ApplicationRecord
  has_many :likes, dependent: :destroy
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :image,   presence: true,
                      content_type: { in: %w[image/jpeg image/gif image/png], message: 'ファイル形式が不正です' },
                      size: { less_than: 5.megabytes, message: '5MB以下のファイルサイズにしてください' }
  validates :content, length: { maximum: 140 }, allow_blank: true
  validates :lat, presence: true
  validates :lng, presence: true
  validates :place_id, presence: true

  # ログイン中のユーザーがその投稿に対していいねをしているか判断する
  def liked?(user)
    return false unless user
    likes.where(user_id: user.id).exists?
  end

  # いいねの数を返す
  def likes_count
    likes.count
  end
end
