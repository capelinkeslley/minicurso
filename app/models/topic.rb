class Topic < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy

  validates :title, :description, presence: true

  scope :accessible_by, ->(user) {
    where("is_private = false OR user_id = ?", user.id)
  }
end
