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
      ['purchase_date', '=', purchase_date_obj.strftime('%Y/%m/%d')],
    ])
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
end
