class Topic < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy

  validates :title, :description, presence: true
end
