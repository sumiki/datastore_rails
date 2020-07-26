module Types
  class HoldingType < Types::BaseObject
    field :id, ID, null: false
    field :ticker_symbol, String, null: false
    field :name, String, null: false
    field :count, Integer, null: false
  end
end
