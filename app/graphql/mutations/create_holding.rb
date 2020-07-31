class Mutations::CreateHolding < Mutations::BaseMutation
  argument :name, String, required: true

  field :holding, Types::HoldingType, null: false
  field :errors, [String], null: false

  def resolve(name:)
    p 'aaaaaa'
    p name
    holding = Holding.new(name: name)
    {
      holding: {},
      errors: []
    }
  end
end
