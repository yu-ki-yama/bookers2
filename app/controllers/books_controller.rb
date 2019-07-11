class BooksController < ApplicationController
  def index
    @image = current_user.profile_image_id
    @user = User.find(current_user.id)
    @book = Book.new

    @books = Book.all
    @users = User.all
  end

  def show
    @book = Book.new
    # @image = current_user.profile_image_id
    # @user = User.find(current_user.id)

    @display_book = Book.find(params[:id])

    @user = User.find(@display_book[:user_id])
    @image = @user.profile_image_id
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
end
