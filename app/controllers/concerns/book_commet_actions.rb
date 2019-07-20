module BookCommet_actions
  extend ActiveSupport::Concern

  def get_book_comment_models(target_book_id)
    models = {
        'comment_error' => nil,
        'edit_comment' => nil,
        'new_comment_model' => BookComment.new,
        'comments' => BookComment.where(book_id: target_book_id)
    }

    unless session[:comment_error].nil?
      models['comment_error'] = session[:comment_error]
      session.delete(:comment_error)
    end

    unless session[:edit_comment].nil?
      models['edit_comment'] = session[:edit_comment]
      session.delete(:edit_comment)
    end

    return models

  end
end