module Beholders
  module CallbackHooks
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

