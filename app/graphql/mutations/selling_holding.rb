class Mutations::SellingHolding < Mutations::BaseMutation
  argument :account_id, Int, required: true
  argument :ticker_symbol, String, required: true
  argument :purchase_price, Float, required: true
  argument :purchase_date, String, required: true
  argument :selling_count, Int, required: true
  argument :selling_price, Float, required: true
  argument :selling_date, String, required: true

  field :holding, Types::HoldingType, null: false
  field :errors, [String], null: false

  def resolve(account_id: ,ticker_symbol:, purchase_price:, purchase_date:,
              selling_count:, selling_price:, selling_date:)

    user_id = context[:current_user]&.[](:id)
    purchase_date_obj = Date.parse(purchase_date)
    selling_date_obj = Date.parse(selling_date)
    Holding.sell(
      user_id: user_id,
      account_id: account_id,
      ticker_symbol: ticker_symbol,
      purchase_price: purchase_price,
      purchase_date: purchase_date_obj.strftime('%Y/%m/%d'),
      selling_count: selling_count,
      selling_price: selling_price,
      selling_date: selling_date_obj.strftime('%Y/%m/%d')
    )
  end
end
