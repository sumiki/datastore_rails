class DatastoreBase
  include ActiveModel::Datastore

  def properties_with_id
    { id: self.id }.merge self.entity_property_values
  end
end
