# Beholders

A lightweight implementation of observer pattern for rails active record models.

Originally developed as an alternative to rails-observers with the goal of:
- Better support for current versions of rails.
- Encourage the 'single responsibility principle' in design- beholders are explicitly added by name to a model, rather than inferred based on its name. This lets you have multiple observers each named for their specific domain.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'beholders'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install beholders

## Usage

Getting started example:

```ruby
# Observers are added to a model like:
class DangerousBeast < ApplicationRecord

  observed_by "TimelineManager"
  observed_by "WarehouseAnnouncer"
  observed_by "Planner::CacheManager"

end

# Your observers inherit from Beholder
class TimelineManager < Beholder
  
  # Define public methods for each callback hook you want to trigger on
  # They should accept 1 arg, the instance of an observed model
  def after_create_commit(subject)
    TimelineEntry.create!(subject: subject)
  end

end

class WarehouseAnnouncer < Beholder
  
  def after_update_commit(model)
    return unless model.previous_changes.include? :arrival_date
    SomeJob.perform_later
  end

end

```

ActiveRecord::Base class methods:

Class name as passed as a string to prevent redundant autoloading.
```ruby
observed_by "BeholderClassName"
```

Callback hooks:

Define as public methods with a single argument (model instance) in your beholders to trigger during that callback stage of the model.

```ruby
after_create
after_update
after_destroy

after_commit
after_create_commit
after_update_commit
after_destroy_commit
```

Beholders can be disabled/enabled individually and globally, which is probably most useful for test isolation. The following class methods are available:

```ruby
MyBeholder.disable! # disable MyBeholder
MyBeholder.enabled! # enable MyBeholder

Beholder.disable_all! # disable Beholder and all descendant classes
Beholder.enable_all!  # enable Beholder and all descendant classes

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Bogadon/beholders. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Beholders project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Bogadon/beholders/blob/master/CODE_OF_CONDUCT.md).
