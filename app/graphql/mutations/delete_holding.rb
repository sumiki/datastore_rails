class Mutations::DeleteHolding < Mutations::BaseMutation
  argument :account_id, Int, required: true
  argument :ticker_symbol, String, required: true
  argument :purchase_price, Float, required: true
  argument :purchase_date, String, required: true

  field :holding, Types::HoldingType, null: false
  field :errors, [String], null: false

  def resolve(account_id: ,ticker_symbol:, purchase_price:, purchase_date:)

    user_id = context[:current_user]&.[](:id)
    purchase_date_obj = Date.parse(purchase_date)

    Holding.delete_details(
      user_id: user_id,
      account_id: account_id,
      ticker_symbol: ticker_symbol,
      purchase_price: purchase_price,
      purchase_date: purchase_date_obj.strftime('%Y/%m/%d')
    )
  end
end
