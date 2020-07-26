class DatastoreBase
  include ActiveModel::Datastore

  def to_json
    { id: self.id }.merge self.entity_property_values
  end
end
