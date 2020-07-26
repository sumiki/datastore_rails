class Account < DatastoreBase

  attr_accessor :user_id, :name, :key

  def entity_properties
    %w[id user_id name key]
  end

end
