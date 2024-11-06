class Post < ApplicationRecord
  belongs_to :topic
  has_one :user, through: :topic

  has_rich_text :content

  validates :title, presence: true
end
