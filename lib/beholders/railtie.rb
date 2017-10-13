# frozen_string_literal: true

module Beholders
  require 'rails'

  class Railtie < Rails::Railtie
    initializer 'beholders.add_to_active_record' do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:extend, CallbackIntegration)
      end
    end
  end

  module CallbackIntegration
    BEHOLDER_CALLBACKS = %i[
      after_save
      after_create
      after_update
      after_destroy
      after_commit
      after_create_commit
      after_update_commit
      after_destroy_commit
    ].freeze

    # Pass class name as string not class, for same reason rails 5.1 deprecates
    # the latter:
    # https://github.com/rails/rails/blob/5-1-stable/activerecord/CHANGELOG.md
    def observed_by(observer)
      instance_eval do
        BEHOLDER_CALLBACKS.each do |cb|
          send cb, -> { observer.constantize.trigger(cb, self) }
        end
      end
    end
  end

end
