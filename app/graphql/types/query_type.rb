module Types
  class QueryType < Types::BaseObject
    # /users
    field :all_holdings, [Types::HoldingType], null: false do
      argument :accountId, ID, required: true
    end

    def all_holdings(accountId:)
      user_id = context[:current_user]&.[](:id)
      holdings = Holding.all( where: [ ['user_id', '=', user_id], ['account_id', '=', accountId.to_i] ] )
      holdings.map{|item| item.properties_with_id }
    end

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end
  end
end
