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

  def self.sell(user_id: ,account_id: ,ticker_symbol:, purchase_price:, purchase_date:,
                selling_count:, selling_price:, selling_date:)

    holding = Holding.all(where: [
      ['account_id', '=', account_id],
      ['user_id', '=', user_id],
      ['ticker_symbol', '=', ticker_symbol],
    ]).first

    if holding.blank?
      return {
        holding: {},
        errors: [
          ticker_symbol: ['Symbol not found']
        ]
      }
    end
    holding_details = HoldingDetail.all(where: [
      ['holding_id', '=', holding.id],
      ['purchase_price', '=', purchase_price],
      ['purchase_date', '=', purchase_date],
    ])
    holding_details = holding_details.select{|item| item.sold_date.blank? }
    if selling_count > holding_details.length
      return {
        holding: {},
        errors: [
          selling_count: ['Not enough Inventory']
        ]
      }
    end
    selling_count.times do |i|
      detail = holding_details[i]
      detail.sold_price = selling_price
      detail.sold_date = selling_date
      detail.save
    end
    holding.set_aggregate_details
    {
      holding: holding,
      errors: []
    }
  end

  def aggregate_details
    JSON.parse(self.aggregate_details_json)
  end

  def set_aggregate_details
    hash = {}
    tcnt = 0
    hcnt = 0
    details.each do |detail|
      key = "#{detail.purchase_date}_#{detail.purchase_price}_#{detail.sold_price}"
      hash[key] ||= {}
      hash[key][:purchase_date] = detail.purchase_date
      hash[key][:count] ||= 0
      hash[key][:count] += 1
      hash[key][:purchase_price_total] ||= 0.0
      hash[key][:purchase_price_total] += detail.purchase_price
      hash[key][:purchase_price] ||= detail.purchase_price
      hash[key][:sold_price] ||= detail.sold_price
      hash[key][:sold_date] ||= detail.sold_date
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
