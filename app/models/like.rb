# frozen_string_literal: true

# Like
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
end