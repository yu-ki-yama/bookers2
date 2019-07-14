class BookComment < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :user_id, presence:true
  validates :book_id, presence: true
  validates :body, presence: true, length: { maximum: 50 }

end
