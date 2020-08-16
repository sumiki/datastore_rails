module Types
  class AggregateDetailType < Types::BaseObject
    field :purchase_date, String, null: true
    field :purchase_price, Float, null: true
    field :count, Int, null: true
    field :purchase_price_total, Float, null: true
    field :sold_date, String, null: true
    field :sold_price, Float, null: true
  end
end
