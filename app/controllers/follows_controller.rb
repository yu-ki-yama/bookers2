class FollowsController < ApplicationController
  include Side_profile_actions
  include Follow_actions

  def show
    @side_profile_models = get_side_profile_models(current_user['id'])
    users = User.all
    follow_list_inf = get_follow_inf(users, Follow.where(user_id: current_user['id']))
    follower_inf_list = get_follower_inf(users)

    @follower_check = follower_inf_list['follower_check_hash']
    @followers = follower_inf_list['follower_array']
    @follow_check = follow_list_inf['follow_check_hash']
    @follows = follow_list_inf['follow_array']

  end

  def new
    user_match = Follow.where(user_id: current_user.id.to_i).where(follow_user_id: params['format'].to_i)
    user_exit = User.find(params['format'].to_i)

    if user_match.empty? && !user_exit.blank? && current_user.id.to_i != params['format'].to_i
      Follow.new(user_id: current_user.id.to_i, follow_user_id: params['format'].to_i).save
      redirect_to users_path
    end
  end

  def destroy
    user_match = Follow.where(user_id: current_user.id.to_i).where(follow_user_id: params['id'].to_i)

    unless user_match.empty?
      Follow.find(user_match[0][:id].to_i).destroy
      redirect_to users_path
    end
  end

end
