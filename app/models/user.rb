class User < ApplicationRecord
  has_many :books, dependent: :destroy

  attachment :profile_image

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
end
