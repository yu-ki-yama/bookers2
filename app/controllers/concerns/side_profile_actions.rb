module Side_profile_actions
  extend ActiveSupport::Concern

  # @return models{'user':class, 'book':class, 'follower_count':int, 'follow_count':int}
  def get_side_profile_models(search_target_user_id)
    models = {}
    models['user'] = User.find(search_target_user_id)
    models['book'] = Book.new
    models['follower_count'] = Follow.where(follow_user_id: search_target_user_id.to_i).count
    models['follow_count'] = Follow.where(user_id: search_target_user_id.to_i).count
    return models
  end

end