module Search_actions
  extend ActiveSupport::Concern

  def search_word(params)
    search_word = params['search']['word']
    search_target = params['search']['search_target']
    search_method = params['search']['search_method']

    if search_target == 'ユーザの検索'
      if search_method == '前方一致検索'
        return User.where('name LIKE ?', "#{search_word}%")
      elsif search_method == '後方一致検索'
        return User.where('name LIKE ?', "%#{search_word}")
      elsif search_method == '部分一致検索'
        return User.where('name LIKE ?', "%#{search_word}%")
      elsif search_method == '完全一致検索'
        return User.where('name LIKE ?', "#{search_word}")
      end

    elsif search_target == '投稿の検索'
      if search_method == '前方一致検索'
        return Book.where('title LIKE ?', "#{search_word}%")
      elsif search_method == '後方一致検索'
        return Book.where('title LIKE ?', "%#{search_word}")
      elsif search_method == '部分一致検索'
        return Book.where('title LIKE ?', "%#{search_word}%")
      elsif search_method == '完全一致検索'
        return Book.where('title LIKE ?', "#{search_word}")
      end

    end

  end
end