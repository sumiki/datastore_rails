class Holding < DatastoreBase

  attr_accessor :user_id,
                :account_id,
                :ticker_symbol,
                :name

    def entity_properties
      %w[user_id account_id ticker_symbol name details]
    end

  def self.tidy_list(holdings)
    hash = {}
    holdings.each do |holding|
      hash[holding.ticker_symbol] ||= {}
      hash[holding.ticker_symbol][:ticker_symbol] ||= holding.ticker_symbol
      hash[holding.ticker_symbol][:name] ||= holding.name
      hash[holding.ticker_symbol][:count] ||= 0
      hash[holding.ticker_symbol][:count] += 1
    end
    hash.keys.map{|key| hash[key] }
  end

  def self.purchase(user_id:, account_id:, ticker_symbol:, name:, purchase_price:, purchase_count:)
    holding = Holding.new
    holding.account_id = account_id
    holding.user_id = user_id
    holding.account_id = nil
    holding.ticker_symbol = ticker_symbol
    holding.name = name
    holding.save

    purchase_count.times do |cnt|
      detail = HoldingDetail.new(
        ticker_symbol: ticker_symbol,
        holding_id: holding.id,
        purchase_price: purchase_price)
      detail.save
    end

    holding
  end

  def details
    HoldingDetail.all(where: ['holding_id', '=', id])
  end

end
