class FollowsController < ApplicationController
  include Side_profile_actions
  include Follow_actions

  def show
    @side_profile_models = get_side_profile_models(current_user['id'])
    users = User.all
    follow_list_inf = get_follow_inf(users, Follow.where(user_id: current_user['id']))
    follower_inf_list = get_follower_inf(users)

    @follower_check = follower_inf_list['follower_check_hash']
    @followers = Kaminari.paginate_array(follower_inf_list['follower_array']).page(params[:page]).per(4)
    @follow_check = follow_list_inf['follow_check_hash']
    @follows = Kaminari.paginate_array(follow_list_inf['follow_array']).page(params[:page]).per(4)

  end

  def new
    user_match = Follow.where(user_id: current_user.id.to_i).where(follow_user_id: params['format'].to_i)
    @user = User.find(params['format'].to_i)

    if user_match.empty? && !@user.blank? && current_user.id.to_i != params['format'].to_i
      Follow.new(user_id: current_user.id.to_i, follow_user_id: params['format'].to_i).save
    end

    @follow_check = {params['format'].to_i => true}

  end

  def destroy
    user_match = Follow.where(user_id: current_user.id.to_i).where(follow_user_id: params['id'].to_i)
    @user = User.find(params['id'].to_i)

    unless user_match.empty?
      Follow.find(user_match[0][:id].to_i).destroy
    end

    @follow_check = {params['id'].to_i => false}

  end

end
