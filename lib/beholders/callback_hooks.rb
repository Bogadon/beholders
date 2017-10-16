module Beholders
  module CallbackHooks
    BEHOLDER_CB_RAILS_3 = %i[
      after_save
      after_create
      after_update
      after_destroy
      after_commit
    ].freeze

    BEHOLDER_CB_RAILS_5 = [
      *BEHOLDER_CB_RAILS_3,
      :after_create_commit,
      :after_update_commit,
      :after_destroy_commit
    ].freeze

    # Pass class name as string not class, for same reason rails 5.1 deprecates
    # the latter:
    # https://github.com/rails/rails/blob/5-1-stable/activerecord/CHANGELOG.md
    def observed_by(observer)
      instance_eval do
        available_callbacks(self).each do |cb|
          send cb, -> { observer.constantize.trigger(cb, self) }
        end
      end
    end

    private

    def available_callbacks(klass)
      if klass.respond_to?(:after_create_commit)
        BEHOLDER_CB_RAILS_5
      else
        BEHOLDER_CB_RAILS_3
      end
    end

  end
end

