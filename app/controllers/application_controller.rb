class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # リダイレクト先を初期設定から変更
  class ApplicationController < ActionController::Base
    def after_sign_in_path_for(resource)

    end
  end

  

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
