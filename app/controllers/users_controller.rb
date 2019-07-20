class UsersController < ApplicationController

  before_action :user_check, only: [:edit, :update]
  include Side_profile_actions
  include Follow_actions

  def index
    @side_profile_models = get_side_profile_models(current_user['id'])
    @users = User.all
    @follow_check = get_follow_inf(@users, Follow.where(user_id: current_user.id.to_i))['follow_check_hash']

  end

  def show
    @side_profile_models = get_side_profile_models(params['id'])
    @books = @side_profile_models['user'].books

  end

  def update
    @user = User.find(current_user['id'])
    if @user.update(user_params)
      redirect_to user_path(current_user['id']), notice: 'You have updated user successfully.'
    else
      render 'users/edit'
    end

  end

  def edit
    @user = User.find(current_user['id'])
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  private
  def user_check
    unless params[:id] == current_user['id'].to_s
      redirect_to user_path(current_user['id'])
    end
  end

end
