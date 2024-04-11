class Micropost < ApplicationRecord
  has_many :likes
  belongs_to :user, dependent: :destroy
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :image,   presence: true, content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message:   "should be less than 5MB" }
  validates :content, length: { maximum: 140 }, allow_blank: true

  # 「ログイン中のユーザーがその投稿に対していいねをしているか」を判断する
  def liked?(user)
    likes.where(user_id: user.id).exists?
  end 
end
