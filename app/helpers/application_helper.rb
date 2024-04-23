# frozen_string_literal: true

# ApplicationHelper
module ApplicationHelper
  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    "#{page_title} | #{base_title}"
  end
end
