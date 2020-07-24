module SourceyExt
  # encrypt tokens using current encryption_provider.
  def encrypt(*tokens)
    return tokens.first if @sorcery_config.encryption_provider.nil?

    set_encryption_attributes

    Sorcery::CryptoProviders::AES256.key = @sorcery_config.encryption_key
    @sorcery_config.encryption_provider.encrypt(*tokens).to_s
  end
end

Sorcery::Model::ClassMethods.prepend(SourceyExt)
