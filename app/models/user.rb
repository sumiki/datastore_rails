class User
  include ActiveModel::Datastore

  attr_accessor :email, :enabled, :name, :role, :state

  def entity_properties
    %w[email enabled name role]
  end
end
