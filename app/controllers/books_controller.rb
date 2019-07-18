class BooksController < ApplicationController
  before_action :book_check, only: [:edit, :update]

  def index
    @image = current_user.profile_image_id
    @user = User.find(current_user.id)
    @book = Book.new
    # フォロ-されている数の抽出
    @follower_count = Follow.where(follow_user_id: current_user.id.to_i).count
    # フォローしている数の抽出
    @follow_count = Follow.where(user_id: current_user.id.to_i).count

    @books = Book.all
    @users = User.all

    # 本のお気に入りの状態を抽出
    hash = {}
    self_check = {}
    @books.each do |book|
      favarites = Favorite.where(book_id: book.id.to_s)
      self_favarite = Favorite.where(book_id: book.id.to_s).where(user_id: current_user.id.to_s)
      if favarites.empty?
        hash[book.id] = 0
      else
        hash[book.id] = favarites.count
      end

      if self_favarite.empty?
        self_check[book.id] = false
      else
        self_check[book.id] = true
      end
    end

    @fav_count = hash
    @fav_self_check = self_check
  end

  def show
    @book = Book.new
    @display_book = Book.find(params[:id])
    @user = User.find(@display_book[:user_id])
    @image = @user.profile_image_id
    @follower_count = Follow.where(follow_user_id: @user['id']).count
    @follow_count = Follow.where(user_id: @user['id']).count
    @comment = BookComment.new
    @comment_error = nil

    @comments = BookComment.where(book_id: params[:id])

    unless session[:comment_error].nil?
      @comment_error = session[:comment_error]
      session.delete(:comment_error)
    end

    unless session[:edit_comment].nil?
      @edit_comment = session[:edit_comment]
      session.delete(:edit_comment)
    end
  end

  def create
    @image = current_user.profile_image_id
    @user = User.find(current_user.id)
    # フォロ-されている数の抽出
    @follower_count = Follow.where(follow_user_id: current_user.id.to_i).count
    # フォローしている数の抽出
    @follow_count = Follow.where(user_id: current_user.id.to_i).count

    @books = Book.all
    @users = User.all

    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @book.save

    # 本のお気に入りの状態を抽出
    hash = {}
    self_check = {}
    @books.each do |book|
      favarites = Favorite.where(book_id: book.id.to_s)
      self_favarite = Favorite.where(book_id: book.id.to_s).where(user_id: current_user.id.to_s)

      if favarites.empty?
        hash[book.id] = 0
      else
        hash[book.id] = favarites.count
      end

      if self_favarite.empty?
        self_check[book.id] = false
      else
        self_check[book.id] = true
      end
    end

    @fav_count = hash
    @fav_self_check = self_check

  end

  def edit
    @book = Book.find(params[:id])
  end

  def destroy
    Book.find(params[:id]).destroy
    redirect_to books_path
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      redirect_to book_path(params[:id]),notice: 'You have updated book successfully.'
    else
      render 'books/edit'
    end
  end

  private
  def book_params
    params.require(:book).permit(:title, :body)
  end

  private
  def book_check
    book = Book.find(params[:id])
    unless book[:user_id] == current_user.id
      redirect_to books_path
    end
  end

end
