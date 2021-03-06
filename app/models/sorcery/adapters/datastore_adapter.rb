module Sorcery
  module Adapters
    class DatastoreAdapter < BaseAdapter
      def update_attributes(attrs)
        attrs.each do |name, value|
          @model.send(:"#{name}=", value)
        end
        primary_key = @model.class.primary_key
        updated_count = @model.class.where(:"#{primary_key}" => @model.send(:"#{primary_key}")).update_all(attrs)
        updated_count == 1
      end

      def save(options = {})
        mthd = options.delete(:raise_on_failure) ? :save! : :save
        @model.send(mthd, options)
      end

      def increment(field)
        @model.increment!(field)
      end

      def find_authentication_by_oauth_credentials(relation_name, provider, uid)
        @user_config ||= ::Sorcery::Controller::Config.user_class.to_s.constantize.sorcery_config
        conditions = {
          @user_config.provider_uid_attribute_name => uid,
          @user_config.provider_attribute_name     => provider
        }

        @model.public_send(relation_name).where(conditions).first
      end

      class << self
        def define_field(name, type, options = {})
          # AR fields are defined through migrations, only validator here
        end

        def define_callback(time, event, method_name, options = {})
          @klass.send "#{time}_#{event}", method_name, options.slice(:if, :on)
        end

        def find_by_oauth_credentials(provider, uid)
          @user_config ||= ::Sorcery::Controller::Config.user_class.to_s.constantize.sorcery_config
          conditions = {
            @user_config.provider_uid_attribute_name => uid,
            @user_config.provider_attribute_name     => provider
          }

          @klass.where(conditions).first
        end

        def find_by_remember_me_token(token)
          @klass.where(@klass.sorcery_config.remember_me_token_attribute_name => token).first
        end

        def find_by_credentials(credentials)
          @klass.sorcery_config.username_attribute_names.each do |attribute|
            @user = @klass.all(where: [attribute, '=', credentials[0]]).first
            break if @user
          end
          @user
        end

        def find_by_token(token_attr_name, token)
          @klass.all(where: [token_attr_name, '=', token]).first
        end

        def find_by_activation_token(token)
          @klass.where(@klass.sorcery_config.activation_token_attribute_name => token).first
        end

        def find_by_id(id)
          @klass.find(id)
        end

        def find_by_username(username)
          @klass.sorcery_config.username_attribute_names.each do |attribute|
            if @klass.sorcery_config.downcase_username_before_authenticating
              username = username.downcase
            end

            result = @klass.where(attribute => username).first
            return result if result
          end
        end

        def find_by_email(email)
          @klass.where(@klass.sorcery_config.email_attribute_name => email).first
        end

        def transaction(&blk)
          @klass.tap(&blk)
        end
      end
    end
  end
end
