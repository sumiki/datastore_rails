class Holding < DatastoreBase

  attr_accessor :user_id,
                :account_id,
                :ticker_symbol,
                :name,
                :total_count,
                :holding_count,
                :aggregate_details_json

  def entity_properties
    %w[user_id account_id ticker_symbol name total_count holding_count aggregate_details_json]
  end

  def additional_properties
    %w[aggregate_details]
  end

  def self.all_aggregate_details(holdings)
    holdings.map{|item| item.properties_with_id }
  end

  def self.purchase(user_id:, account_id:, ticker_symbol:, name:, purchase_price:, purchase_count:, purchase_date:)
    holding = Holding.all(where:
                  [[ 'user_id', '=', user_id ],
                   ['account_id', '=', account_id],
                   ['ticker_symbol', '=', ticker_symbol]]
    ).first
    if holding.blank?
      holding = Holding.new
      holding.account_id = account_id
      holding.user_id = user_id
      holding.ticker_symbol = ticker_symbol
      holding.name = name
      holding.save
    end

    purchase_count.times do |cnt|
      detail = HoldingDetail.new(
        ticker_symbol: ticker_symbol,
        holding_id: holding.id,
        purchase_price: purchase_price,
        purchase_date: purchase_date,
      )
      detail.save
    end

    holding
  end

  def aggregate_details
    JSON.parse(self.aggregate_details_json)
  end

  def set_aggregate_details
    hash = {}
    tcnt = 0
    hcnt = 0
    details.each do |detail|
      key = "#{detail.purchase_date}_#{detail.purchase_price}"
      hash[key] ||= {}
      hash[key][:purchase_date] = detail.purchase_date
      hash[key][:count] ||= 0
      hash[key][:count] += 1
      hash[key][:price] ||= 0.0
      hash[key][:price] += detail.purchase_price
      tcnt += 1
      hcnt += 1 if detail.sold_price.blank?
    end
    self.total_count = tcnt
    self.holding_count = hcnt
    self.aggregate_details_json = hash.keys.map{|key| hash[key] }.to_json
    save!
  end

  def details
    HoldingDetail.all(where: ['holding_id', '=', id])
  end

end
