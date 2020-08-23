module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :create_holding, mutation: Mutations::CreateHolding
    field :selling_holding, mutation: Mutations::SellingHolding
    field :deleting_holding, mutation: Mutations::DeleteHolding
  end
end
