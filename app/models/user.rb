class User < DatastoreBase

  extend Sorcery::Model
  def sorcery_adapter
    @sorcery_adapter ||= Sorcery::Adapters::DatastoreAdapter.new(self)
  end

  def self.sorcery_adapter
    Sorcery::Adapters::DatastoreAdapter.from(self)
  end

  authenticates_with_sorcery!

  attr_accessor :name, :email, :crypted_password, :salt

  def entity_properties
    %w[name email crypted_password salt]
  end
end
