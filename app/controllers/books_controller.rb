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
    book = Book.new(book_params)
    book['user_id'] = current_user.id
    book.save

    unless book['profile_image_id'].nil?
      session.delete(:book_cover_url)
    end

    unless session[:book_cover_url].nil?
      uri = URI.parse(session[:book_cover_url])
      timestamp = Time.now.to_i
      File.open("./app/assets/images/#{timestamp}.jpg", "wb") do |file|
        open(uri) do |img|
          file.puts img.read
        end
      end

      update_book = Book.find(book['id'])
      update_parms = book_params
      update_parms["profile_image"] = File.open("./app/assets/images/#{timestamp}.jpg")
      update_book.update(update_parms)

      FileUtils.rm("./app/assets/images/#{timestamp}.jpg")
      session.delete(:book_cover_url)

    end

    if params[:url] == '/books'
      redirect_to books_path
    end

    if params[:url] == "/users/#{current_user['id']}"
      redirect_to user_path(current_user['id'])
    end

    @book = Book.new

  end

  def cover_search
    session.delete(:book_cover_url)
    url = "https://iss.ndl.go.jp/thumbnail/#{params['cover_search']}"
    uri = URI.parse(url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = (uri.scheme == 'https')
    https.open_timeout = 10
    https.read_timeout = 60
    response = https.get(uri.request_uri)

    begin

      case response

      when Net::HTTPSuccess
        session[:book_cover_url] = url

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
    book = book_params

    unless book_params['profile_image'] === "{}"
      session.delete(:book_cover_url)
      if @book.update(book)
        redirect_to book_path(params[:id]),notice: 'You have updated book successfully.'
      else
        render 'books/edit'
      end
    else

      uri = URI.parse(session[:book_cover_url])
      timestamp = Time.now.to_i
      File.open("./app/assets/images/#{timestamp}.jpg", "wb") do |file|
        open(uri) do |img|
          file.puts img.read
        end
      end

      book["profile_image"] = File.open("./app/assets/images/#{timestamp}.jpg")
      if @book.update(book)
        redirect_to book_path(params[:id]),notice: 'You have updated book successfully.'
      else
        render 'books/edit'
      end

      FileUtils.rm("./app/assets/images/#{timestamp}.jpg")
      session.delete(:book_cover_url)
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
    params.require(:book).permit(:title, :body, :profile_image)
  end

  private
  def book_check
    book = Book.find(params['id'])
    unless book['user_id'] == current_user['id']
      redirect_to books_path
    end
  end

end
