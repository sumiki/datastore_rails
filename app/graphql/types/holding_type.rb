module Types
  class HoldingType < Types::BaseObject
    field :id, ID, null: true
    field :ticker_symbol, String, null: true
    field :name, String, null: true
    field :count, Integer, null: true
  end
end
