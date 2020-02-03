# frozen_string_literal: true

module SolidusAvataxCertified
  class PreferenceSeeder
    class << self
      def seed!(print_messages = true)
        @print_messages = print_messages
        stored_env_prefs
        boolean_prefs
        enabled_countries_pref
        origin_address
      end

      protected

      def stored_env_prefs
        ::Spree::AvataxConfiguration.storable_env_preferences.each do |env|
          value = if !ENV["AVATAX_#{env.upcase}"].blank?
                    ENV["AVATAX_#{env.upcase}"]
                  end

          ::Spree::Avatax::Config[env.to_sym] = value
        end
      end

      def boolean_prefs
        ::Spree::AvataxConfiguration.boolean_preferences.each do |preference|
          ::Spree::Avatax::Config[preference.to_sym] = if ['refuse_checkout_address_validation_error', 'log_to_stdout', 'raise_exceptions'].include?(preference)
                                                       false
                                                     else
                                                       true
                                                     end
        end
      end

      def enabled_countries_pref
        ::Spree::Avatax::Config.address_validation_enabled_countries = ['United States', 'Canada']
      end

      def origin_address
        origin = ::Spree::Avatax::Config.origin
        origin = "{}" if origin.nil?
      end

      def success_message(name, value)
        puts "Created: #{name} - #{value || 'Please input value in avalara settings!'}"
      end
    end
  end
end
