class UsersController < ApplicationController
  before_action :user_check, only: [:edit, :update]
  before_action :index_login_check, only:[:index]

  def index
    # 新規本の登録用
    @book = Book.new
    # 全ユーザ情報
    @users = User.all
    # プロフィール写真
    @image = current_user.profile_image_id
    # ログイン中のユーザー情報
    @user = User.find(current_user.id)
    # ログインユーザーがフォローしている一覧抽出
    current_user_follow_list = Follow.where(user_id: current_user.id.to_i)


    # フォロ-されている数の抽出
    @follower_count = Follow.where(follow_user_id: current_user.id.to_i).count

    #フォローしているかどうかの抽出
    @follow_count = 0
    follow_check_hash = {}
    @users.each do |user|
      unless current_user_follow_list.blank?
        current_user_follow_list.each do |follow|
            if user['id'] == follow['follow_user_id']
              follow_check_hash[user['id']] = true
              @follow_count += 1
              break
            else
              follow_check_hash[user['id']] = false
            end
        end
      else
        follow_check_hash[user['id']] = false
      end
    end

    @follow_check = follow_check_hash

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
    # フォロ-されている数の抽出
    @follower_count = Follow.where(follow_user_id: @user['id']).count
    # フォローしている数の抽出
    @follow_count = Follow.where(user_id: @user['id']).count

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
    unless params[:id] == current_user.id.to_s
      redirect_to user_path(current_user.id)
    end
  end

  private
  def index_login_check
    unless user_signed_in?
      redirect_to new_user_session_path
    end

  end
end
