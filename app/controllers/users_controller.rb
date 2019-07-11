class UsersController < ApplicationController
  before_action :user_check, only: [:edit, :update]

  def index
    # 新規本の登録用
    @book = Book.new
    # 全ユーザ情報
    @users = User.all
    # プロフィール写真
    @image = current_user.profile_image_id
    # ログイン中のユーザー情報
    @user = User.find(current_user.id)

  end

  def show
    # ログイン中のユーザー情報
    @user = User.find(params[:id])
    # 新規本の登録用
    @book = Book.new
    # ログイン中のユーザーの投稿情報
    @books = @user.books
    # プロフィール写真
    @image = @user.profile_image_id

  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to user_path(current_user.id), notice: 'You have updated user successfully.'
    else
      render 'users/edit'
    end


  end

  def edit
    @user = User.find(current_user.id)
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  private
  def user_check
    unless params[:id] == current_user.id
      redirect_to user_path(current_user.id)
    end
  end
end
