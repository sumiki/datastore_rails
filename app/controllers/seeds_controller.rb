class SeedsController < ApplicationController

  def index
    user = User.all(where: ['email', '=', 'sumikio@gmail.com']).first
    if user.present?
      account0 = Account.all(where: [['user_id', '=', user.id], ['key', '=', "#{user.id}-0"]]).first
      if account0.blank?
        account0 = Account.new
        account0.user_id = user.id
        account0.name = 'Default'
        account0.key = "#{user.id}-0"
        account0.save
      end

      account1 = Account.all(where: [['user_id', '=', user.id], ['key', '=', "#{user.id}-1"]]).first
      if account1.blank?
        account1 = Account.new
        account1.user_id = user.id
        account1.name = 'IRA'
        account1.key = "#{user.id}-1"
        account1.save
      end

      holdings = Holding.all(where: [['account_id', '=', account0.id], ['user_id', '=', user.id]])
      if holdings.blank?
        5.times do
          holding = Holding.new
          holding.user_id = user.id
          holding.account_id = account0.id
          holding.ticker_symbol = 'SPY'
          holding.name = 'SP500'
          holding.purchase_price = 310
          holding.purchase_date = Time.zone.now - 10.days
          holding.save
        end
      end
    end
    render plain: 'ok'
  end

end
