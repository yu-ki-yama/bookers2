class BooksController < ApplicationController
  before_action :book_check, only: [:edit, :update]
  before_action :index_login_check, only: [:index]

  def index
    @image = current_user.profile_image_id
    @user = User.find(current_user.id)
    @book = Book.new

    @books = Book.all
    @users = User.all

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

    @books = Book.all
    @users = User.all

    @book = Book.new(book_params)
    @book.user_id = current_user.id

    if @book.save
      redirect_to book_path(@book.id), notice: 'You have creatad book successfully.'
    else
      render 'books/index'
    end
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

  private
  def index_login_check
    unless user_signed_in?
      redirect_to new_user_session_path
    end

  end

end
