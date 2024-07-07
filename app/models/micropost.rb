require 'httparty'

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
  validates :content, length: { maximum: 120 }, allow_blank: true
  validates :place_id, presence: true
  validates :aspect_ratio, presence: true

  # ログイン中のユーザーがその投稿に対していいねをしているか判断する
  def liked?(user)
    return false unless user
    likes.where(user_id: user.id).exists?
  end

  # いいねの数を返す
  def likes_count
    likes.count
  end

  # place_idから場所の名前を取得する
  def place_name(place_id)
    response = HTTParty.get("https://maps.googleapis.com/maps/api/place/details/json?placeid=#{place_id}&key=#{ENV['GOOGLE_MAPS_API_KEY']}&language=ja")
    if response.success?
      response.dig('result', 'name')
    else
      '不明な場所'
    end
  end
end
