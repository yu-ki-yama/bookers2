class FollowsController < ApplicationController

  def show
    # ログイン中のユーザー情報
    @user = User.find(params[:id])
    # 新規本の登録用
    @book = Book.new
    # ログイン中のユーザーの投稿情報
    @books = @user.books
    # プロフィール写真
    @image = @user.profile_image_id

    follower_check_hash = {}
    users = User.all
    followers = Follow.where(follow_user_id: current_user.id)
    @follower_count = followers.count
    # 全ユーザ情報からフォローしてくれているユーザを検索して取得
    followers_array = []
    followers.each do |follower|
      users.each do |user|
        if follower['user_id'] == user['id']
          followers_array.push(user)
          follower_check_hash[user['id']] = true
          break
        end
      end
    end

    current_user_follow_list = Follow.where(user_id: current_user.id)
    @follow_count = current_user_follow_list.count
    follow_check_hash = {}
    users.each do |user|
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

    # フォローしている人の情報を抽出
    follows_array = []
    current_user_follow_list.each do |follow|
      users.each do |user|
        if follow['follow_user_id'] == user['id']
          follows_array.push(user)
          break
        end
      end
    end

    @follower_check = follower_check_hash
    @follow_check = follow_check_hash
    @followers = followers_array
    @follows = follows_array
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
