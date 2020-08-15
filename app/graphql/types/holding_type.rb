module Types
  class HoldingType < Types::BaseObject
    field :id, ID, null: true
    field :account_id, Int, null: true
    field :ticker_symbol, String, null: true
    field :name, String, null: true
    field :count, Int, null: true
    field :aggregate_details, [Types::AggregateDetailType], null: true
  end
end
