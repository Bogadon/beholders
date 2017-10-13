# frozen_string_literal: true

require 'rails/railtie'

require 'beholders/callback_hooks'

module Beholders

  class Railtie < Rails::Railtie
    initializer 'beholders.add_to_active_record' do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:extend, CallbackHooks)
      end
    end
  end

end
