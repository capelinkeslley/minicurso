class Post < ApplicationRecord
  belongs_to :topic
  has_one :user, through: :topic

  validates :title, :content, presence: true

  has_rich_text :content
end
