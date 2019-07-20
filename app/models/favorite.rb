class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates :user_id, presence:true
  validates :book_id, presence: true

  class << self
    def favarite_save(target_book_id, login_user_id)
      user_match = Favorite.where(user_id: login_user_id.to_i).where(book_id: target_book_id.to_i)
      book_exit = Book.find(target_book_id.to_i)

      if user_match.empty? && !book_exit.blank?
        Favorite.new(user_id: login_user_id.to_i, book_id: target_book_id.to_i).save
      end

    end

    def favarite_delete(target_book_id, login_user_id)
      user_match = Favorite.where(user_id: login_user_id.to_i).where(book_id: target_book_id.to_i)

      unless user_match.empty?
        Favorite.find(user_match[0]['id'].to_i).destroy
      end
    end

  end
end
