module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :create_holding, mutation: Mutations::CreateHolding
  end
end
