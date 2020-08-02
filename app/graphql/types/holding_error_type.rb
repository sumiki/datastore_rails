module Types
  class HoldingErrorType < Types::BaseObject
    field :ticker_symbol, [String], null: true
    field :name, [String], null: true
    field :count, [String], null: true
  end
end
