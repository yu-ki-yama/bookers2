module Follow_actions
  extend ActiveSupport::Concern

  def get_follow_inf(users, follow_list)
    follow_check_hash = {}
    users.each do |user|
      unless follow_list.blank?
        follow_list.each do |follow|
          if user['id'] == follow['follow_user_id']
            follow_check_hash[user['id']] = true
            break
          else
            follow_check_hash[user['id']] = false
          end
        end
      else
        follow_check_hash[user['id']] = false
      end

    end

    follow_array = []
    follow_list.each do |follow|
      users.each do |user|
        if follow['follow_user_id'] == user['id']
          follow_array.push(user)
          break
        end
      end
    end


    return {'follow_check_hash' => follow_check_hash, 'follow_array' => follow_array}
  end

  def get_follower_inf(users)
    follower_check_hash = {}
    follower_array = []
    Follow.where(follow_user_id: current_user['id']).each do |follower|
      users.each do |user|
        if follower['user_id'] == user['id']
          follower_array.push(user)
          follower_check_hash[user['id']] = true
          break
        end
      end
    end

    return {'follower_check_hash' => follower_check_hash, 'follower_array' => follower_array}

  end

end