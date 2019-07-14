class FavoritesController < ApplicationController
  before_action :prohibited_area_check, only: [:new]
  def show
    puts "-------------------------"
    puts params.inspect

    match_users = Favorite.where(book_id: params['format'])

    user_array = []
    match_users.each do |user|
      user_array.push(User.find(user['user_id'].to_i))
    end

    @users = user_array

    # 新規本の登録用
    @book = Book.new
    # プロフィール写真
    @image = current_user.profile_image_id
    # ログイン中のユーザー情報
    @user = User.find(current_user.id)
  end

  def new
    user_match = Favorite.where(user_id: current_user.id.to_i).where(book_id: params['format'].to_i)

    if user_match.empty?
       Favorite.new(user_id: current_user.id.to_i, book_id: params['format'].to_i).save
       redirect_to books_path
    end

  end

  def destroy
    user_match = Favorite.where(user_id: current_user.id.to_i).where(book_id: params['id'].to_i)

    unless user_match.empty?
      Favorite.find(user_match[0][:id].to_i).destroy
      redirect_to books_path
    end

  end

  #overrideでフィルター打ち消し
  private
  def prohibited_area_check
  end
end