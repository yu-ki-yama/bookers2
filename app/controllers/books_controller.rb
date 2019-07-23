class BooksController < ApplicationController
  before_action :book_check, only: [:edit, :update]
  include Favorite_actions
  include Side_profile_actions
  include BookCommet_actions

  def index
    @side_profile_models = get_side_profile_models(current_user['id'])

    models = get_favorite_count_model(current_user['id'])
    models['books'] = Book.page(params[:page]).per(6)
    models['users'] = User.all
    @book_list_table_models = models

  end

  def show
    @book = Book.find(params['id'])
    @side_profile_models = get_side_profile_models(@book['user_id'])
    @comment_models = get_book_comment_models(params['id'])
    @comment_models['comments'] = @comment_models['comments'].page(params[:page]).per(3)

  end

  def create
    # book = Book.new(book_params)
    # book['user_id'] = current_user.id
    # book.save
    #
    # if params[:url] =='/books'
    #   redirect_to books_path
    # end

    uri = URI.parse("https://iss.ndl.go.jp/thumbnail/#{book_params['test']}")

      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = (uri.scheme == 'https')
      https.open_timeout = 10
      https.read_timeout = 60
      response = https.get(uri.request_uri)

    begin

      case response

      when Net::HTTPSuccess
        puts response.inspect

        File.open("hoge.jpg", "wb") do |file|
          open(uri) do |img|
            file.puts img.read
          end
        end

      when Net::HTTPRedirection
        message = "Redirection: code=#{response.code} message=#{response.message}"
        puts message
      else
        message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
        puts message
      end
    rescue IOError => e
      puts e.inspect
    rescue TimeoutError => e
      puts e.inspect
    rescue JSON::ParserError => e
      puts e.inspect
    rescue => e
      puts e.inspect
    end

  end

  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      redirect_to book_path(params[:id]),notice: 'You have updated book successfully.'
    else
      render 'books/edit'
    end
  end

  def edit
    @book = Book.find(params['id'])
  end

  def destroy
    Book.find(params['id']).destroy
    redirect_to books_path
  end

  private
  def book_params
    params.require(:book).permit(:title, :body, :test)
  end

  private
  def book_check
    book = Book.find(params['id'])
    unless book['user_id'] == current_user['id']
      redirect_to books_path
    end
  end

end
