[![Build Status](https://travis-ci.org/Bogadon/beholders.svg?branch=master)](https://travis-ci.org/Bogadon/beholders)

# Beholders

A lightweight implementation of the [observer pattern] for rails active record models.

Originally developed as an alternative to [rails-observers] with the goal of:
- Better support for current versions of rails.
- Encourage the [single responsibility principle] in design- beholders are explicitly added by name to a model, rather than inferred based on its name. This lets you have multiple observers each named for their specific domain.

Supports rails 4.0+ (tested up to 5.1).

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
class Train < ApplicationRecord
  observed_by "TimelineManager"
  observed_by "PlatformAnnouncer"
  observed_by "Planner::RisksCacher"
end

# Your observers inherit from Beholder
class TimelineManager < Beholder
  # Define public methods for each callback hook you want to trigger on
  # They should accept 1 arg, the instance of an observed model
  def after_create_commit(subject)
    TimelineEntry.create!(subject: subject)
  end
end

class PlatformAnnouncer < Beholder
  def after_update_commit(subject)
    return unless subject.previous_changes.include? :arrival_time
    # broadcast an event to your action cable channel
  end
end

```

ActiveRecord::Base class methods:

Class names are passed as a string to prevent redundant autoloading.
```ruby
observed_by "BeholderClassName"
```

Callback hooks:

Define as public methods with a single argument (model instance) in your beholders to trigger during that callback stage of the model.
```ruby
after_save
after_create
after_update
after_destroy

after_commit
after_create_commit
after_update_commit
after_destroy_commit
```

Beholders are enabled by default and can be disabled/enabled individually and globally, which is probably most useful for test isolation. The following class methods are available:

```ruby
class MyBeholder < Beholder; end

MyBeholder.disable!  # disable MyBeholder
MyBeholder.disabled? # true
MyBeholder.enable!   # enable MyBeholder
MyBeholder.disabled? # false

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

[observer pattern]: https://en.wikipedia.org/wiki/Observer_pattern
[rails-observers]: https://github.com/rails/rails-observers
[single responsibility principle]: https://en.wikipedia.org/wiki/Single_responsibility_principle
