class LoginController < ApplicationController
  def index
  end

  def create
    if login(params[:email], params[:password])
      redirect_to session[:return_to_url] || '/member'
    else
      redirect_to(action: :index)
    end
  end

  def logout
    return unless logged_in?

    user = current_user
    @current_user = nil
    reset_sorcery_session
    redirect_to(action: :index)
  end
end
