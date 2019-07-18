class FavoritesController < ApplicationController

  def show
    # 新規本の登録用
    @book = Book.new
    # プロフィール写真
    @image = current_user.profile_image_id
    # ログイン中のユーザー情報
    @user = User.find(current_user.id)
    # フォロ-されている数の抽出
    @follower_count = Follow.where(follow_user_id: current_user.id.to_i).count
    # フォローしている数の抽出
    @follow_count = Follow.where(user_id: current_user.id.to_i).count

    match_users = Favorite.where(book_id: params['format'])

    user_array = []
    match_users.each do |user|
      user_array.push(User.find(user['user_id'].to_i))
    end

    @users = user_array


  end

  def new
    user_match = Favorite.where(user_id: current_user.id.to_i).where(book_id: params['format'].to_i)
    book_exit = Book.find(params['format'].to_i)

    if user_match.empty? && !book_exit.blank?
       Favorite.new(user_id: current_user.id.to_i, book_id: params['format'].to_i).save

    end

    @book = Book.find(params['format'].to_i)
    hash = {}
    self_check = {}
    favarites = Favorite.where(book_id: @book.id.to_s)
    self_favarite = Favorite.where(book_id: @book.id.to_s).where(user_id: current_user.id.to_s)
    if favarites.empty?
      hash[@book.id] = 0
    else
      hash[@book.id] = favarites.count
    end

    if self_favarite.empty?
      self_check[@book.id] = false
    else
      self_check[@book.id] = true
    end


    @fav_count = hash
    @fav_self_check = self_check

  end

  def destroy
    user_match = Favorite.where(user_id: current_user.id.to_i).where(book_id: params['id'].to_i)

    unless user_match.empty?
      Favorite.find(user_match[0][:id].to_i).destroy

    end

    @book = Book.find(params['id'].to_i)
    hash = {}
    self_check = {}
    favarites = Favorite.where(book_id: @book.id.to_s)
    self_favarite = Favorite.where(book_id: @book.id.to_s).where(user_id: current_user.id.to_s)
    if favarites.empty?
      hash[@book.id] = 0
    else
      hash[@book.id] = favarites.count
    end

    if self_favarite.empty?
      self_check[@book.id] = false
    else
      self_check[@book.id] = true
    end


    @fav_count = hash
    @fav_self_check = self_check

  end

end
