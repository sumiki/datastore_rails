module Types
  class AggregateDetailType < Types::BaseObject
    field :purchase_date, String, null: true
    field :purchase_price, Float, null: true
    field :count, Int, null: true
    field :price, Float, null: true
  end
end
