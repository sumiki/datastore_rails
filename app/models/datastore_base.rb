class DatastoreBase
  include ActiveModel::Datastore

  def properties_with_id
    hash = { id: self.id }.merge self.entity_property_values
    self.additional_properties.each do |ap|
      hash[ap] = self.send ap
    end if self.respond_to? :additional_properties
    hash
  end
end
