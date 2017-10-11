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
    # Pass class name as string not class, for same reason rails 5.1 deprecates
    # the latter:
    # https://github.com/rails/rails/blob/5-1-stable/activerecord/CHANGELOG.md
    def observed_by(observer)
      instance_eval do
        after_create -> { observer.constantize.trigger(:after_create, self) }
        after_update -> { observer.constantize.trigger(:after_update, self) }
        after_destroy -> { observer.constantize.trigger(:after_destroy, self) }
        after_commit -> { observer.constantize.trigger(:after_commit, self) }
        after_create_commit -> { observer.constantize.trigger(:after_create_commit, self) }
        after_update_commit -> { observer.constantize.trigger(:after_update_commit, self) }
        after_destroy_commit -> { observer.constantize.trigger(:after_destroy_commit, self) }
      end
    end
  end

end
