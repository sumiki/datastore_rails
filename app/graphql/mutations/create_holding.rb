class Mutations::CreateHolding < Mutations::BaseMutation
  argument :account_id, Int, required: true
  argument :name, String, required: true
  argument :ticker_symbol, String, required: true
  argument :purchase_count, Int, required: true
  argument :purchase_price, Float, required: true

  field :holding, Types::HoldingType, null: false
  field :errors, [String], null: false

  def resolve(name:, account_id: ,ticker_symbol:, purchase_count:, purchase_price:)
    user_id = context[:current_user]&.[](:id)
    holding = Holding.purchase(
      user_id: user_id,
      account_id: account_id,
      ticker_symbol: ticker_symbol,
      name: name,
      purchase_count: purchase_count,
      purchase_price: purchase_price
    )

    {
      holding: holding,
      errors: []
    }
  end
end
