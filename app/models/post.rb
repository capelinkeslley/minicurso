class Post < ApplicationRecord
  belongs_to :topic
  has_one :user, through: :topic

  validates :title, :content, presence: true
end
