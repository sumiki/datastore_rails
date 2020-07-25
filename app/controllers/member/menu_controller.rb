class Member::MenuController < ApplicationController
  before_action :require_login

  def index
  end

  protected

  def not_authenticated
    redirect_to login_url, alert: 'ログインしてください'
  end
end
