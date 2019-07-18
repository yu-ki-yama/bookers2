class BookCommentsController < ApplicationController

  def create
    # @book = Book.new
    # @display_book = Book.find(comment_params[:book_id])
    # @user = User.find(@display_book[:user_id])
    # @image = @user.profile_image_id
    # # フォロ-されている数の抽出
    # @follower_count = Follow.where(follow_user_id: current_user.id.to_i).count
    # # フォローしている数の抽出
    # @follow_count = Follow.where(user_id: current_user.id.to_i).count

    @comment = BookComment.new(comment_params)
    @comment.user_id = current_user.id

    if @comment.save

      redirect_to book_path(@comment.book_id), notice: 'You have creatad comment successfully.'
    else
      session[:comment_error] = @comment.errors.full_messages
      redirect_to book_path(@comment.book_id)
    end
  end

  def destroy
    comment = BookComment.find(params[:id])
    comment.destroy
    redirect_to book_path(comment.book_id)
  end

  def edit
    comment = BookComment.find(params[:id])
    session[:edit_comment] = comment
    redirect_to book_path(comment.book_id)
  end

  def update
    comment_id = params[:comment_id]
    comment = BookComment.find(comment_id)
    comment['body'] = params['body']

    if comment.save
      redirect_to book_path(params['id']),notice: 'You have updated comment successfully.'
    else
      session[:comment_error] = @comment.errors.full_messages
      redirect_to book_path(@comment.book_id)
    end
  end

  private
  def comment_params
    params.require(:book_comment).permit(:body, :book_id)
  end
end
