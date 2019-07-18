class User < ApplicationRecord
  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :follows, dependent:  :destroy

  attachment :profile_image

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  validates :name, presence: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first

    unless user
      user = User.create(
          uid:      auth.uid,
          provider: auth.provider,
          name: auth.info.name,
          email:    auth.info.email,
          password: Devise.friendly_token[0, 20]
      )
    end

    user
  end
end
