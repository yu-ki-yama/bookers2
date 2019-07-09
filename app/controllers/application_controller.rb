class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # リダイレクト先を初期設定から変更
  # ログイン後
  def after_sign_in_path_for(resource)
    user_path(resource.id)
  end

  # ログアウト後
  def after_sign_out_path_for(resource)
    root_path
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
