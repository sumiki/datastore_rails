class Account < DatastoreBase

  attr_accessor :user_id, :name, :key

  def entity_properties
    %w[user_id name key]
  end

end
