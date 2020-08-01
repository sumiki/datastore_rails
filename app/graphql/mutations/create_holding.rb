class Mutations::CreateHolding < Mutations::BaseMutation
  argument :name, String, required: true
  argument :ticker_symbol, String, required: true
  argument :purchase_count, Int, required: true
  argument :purchase_price, Float, required: true

  field :holding, Types::HoldingType, null: false
  field :errors, [String], null: false

  def resolve(name:, ticker_symbol:, purchase_count:, purchase_price:)
    holding = Holding.new(
      name: name,
      ticker_symbol: ticker_symbol
    )

    holding = Holding.new
    holding.user_id = nil
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

    {
      holding: holding,
      errors: []
    }
  end
end
