class SearchsController < ApplicationController

  include SearchsHelper

  def index
    @search_results = searchs_helper_search_word(params)
    @search_target = params['search']['search_target'] == 'ユーザの検索' ? "ユーザー" : "投稿"
    @search_method = params['search']['search_method']

    @users = User.all
    current_user_follow_list = Follow.where(user_id: current_user.id.to_i)
    follow_check_hash = {}
    @users.each do |user|
      unless current_user_follow_list.blank?
        current_user_follow_list.each do |follow|
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

    @follow_check = follow_check_hash

    # 本のお気に入りの状態を抽出
    hash = {}
    self_check = {}
    @search_results.each do |book|
      favarites = Favorite.where(book_id: book.id.to_s)
      self_favarite = Favorite.where(book_id: book.id.to_s).where(user_id: current_user.id.to_s)
      if favarites.empty?
        hash[book.id] = 0
      else
        hash[book.id] = favarites.count
      end

      if self_favarite.empty?
        self_check[book.id] = false
      else
        self_check[book.id] = true
      end
    end

    @fav_count = hash
    @fav_self_check = self_check


  end

end
