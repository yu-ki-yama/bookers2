module Favorite_actions
  extend ActiveSupport::Concern

  # return models{'fav_count':{...}, 'fav_self_check':{...}}
  def get_favorite_count_model(search_target_user_id)
    models = {}
    favorite_counts_list = {}
    self_favorite_list= {}
    favorites = Favorite.all

    favorites.each do |favorite|
      # [self_favorite_book_id] = {1:true, 2:true, 4:true, 5:true ...}
      if favorite['user_id'] == search_target_user_id
        self_favorite_list[favorite['book_id']] = true
      end

      # {book_id:favorite_count} = {1:3, 3:4, 4:5 ...}
      if favorite_counts_list.has_key?(favorite['book_id'])
        favorite_counts_list[favorite['book_id']] +=1
      else
        favorite_counts_list[favorite['book_id']] = 1
      end
    end

    models['fav_count'] = favorite_counts_list
    models['fav_self_check'] = self_favorite_list
    return models
  end

  #TODO ロジックを変更する必要あり
  def get_favarite_match_user_array(target_book_id)
    match_users = Favorite.where(book_id: target_book_id)

    user_array = []
    match_users.each do |user|
      user_array.push(User.find(user['user_id'].to_i))
    end

    return user_array
  end

end
