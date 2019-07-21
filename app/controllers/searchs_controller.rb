class SearchsController < ApplicationController
  include Search_actions
  include Favorite_actions
  include Follow_actions

  def index
    @search_results = search_word(params).page(params[:page]).per(params['search']['search_target'] == 'ユーザの検索' ? 9 : 7)
    @search_target = params['search']['search_target'] == 'ユーザの検索' ? "ユーザー" : "投稿"
    @search_method = params['search']['search_method']

    @users = User.all
    @follow_check = get_follow_inf(@users, Follow.where(user_id: current_user.id.to_i))['follow_check_hash']
    @fav_check = get_favorite_count_model(current_user['id'])


  end

end
