require "rails/railtie"

module AsyncMagic
  class Railtie < ::Rails::Railtie
    initializer "async_magic.configure_inclusion" do
      case AsyncMagic.include_in
      when :active_record
        ActiveSupport.on_load(:active_record) do
          ActiveRecord::Base.include AsyncMagic
        end
      when :global
        Object.include AsyncMagic
      else
        # If :include_in is anything else (including nil), do not auto-include.
        # The user must manually include AsyncMagic in their classes.
      end
    end

    at_exit do
      AsyncMagic.shutdown
    end
  end
end
