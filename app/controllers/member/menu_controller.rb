class Member::MenuController < ApplicationController
  before_action :require_login

  def index
    @accounts = Account.all(where: [ 'user_id', '=', current_user.id ])
    @server_side_values = {
      accounts: @accounts.map{|item| item.properties_with_id },
    }
  end

  protected

  def not_authenticated
    redirect_to login_index_url, alert: 'ログインしてください'
  end
end
