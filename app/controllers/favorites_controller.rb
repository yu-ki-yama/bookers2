class FavoritesController < ApplicationController
  include Favorite_actions
  include Side_profile_actions

  def show

    @side_profile_models = get_side_profile_models(current_user['id'])
    @match_users = get_favarite_match_user_array(params['id'])

  end

  def new

    Favorite.favarite_save(params['format'], current_user['id'])
    @book_list_table_models = get_favorite_count_model(current_user['id'])
    @book = {'id' => params['format'].to_i}

  end

  def destroy

    Favorite.favarite_delete(params['id'], current_user['id'])
    @book_list_table_models = get_favorite_count_model(current_user['id'])
    @book = {'id' => params['id'].to_i}

  end

end
