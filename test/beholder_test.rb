require 'test_helper'

class BeholderTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Beholders::VERSION
  end

  def setup
    Beholder.enable_all!
    Character.delete_all
    Creature.delete_all
  end

  def test_fire_on_callbacks
    assert_equal Pickpocket.disabled?, false
    assert_equal Necromancer.disabled?, false

    # Pickpocket
    subject = Character.create!(name: 'Bob', gold: 100)

    assert_equal subject.gold, 99

    subject.destroy!

    # Necromancer
    assert_equal 0, Character.count
    assert_equal 1, Creature.count
  end

  def test_can_be_disabled_globally
    Beholder.disable_all!

    assert_equal Pickpocket.disabled?, true
    assert_equal Necromancer.disabled?, true

    subject = Character.create!(name: 'Bob', gold: 100)

    # No pickpocket
    assert_equal subject.gold, 100

    subject.destroy!

    # No necromancer
    assert_equal 0, Character.count
    assert_equal 0, Creature.count
  end

  def test_can_be_disabled_individually
    Necromancer.disable!

    assert_equal Pickpocket.disabled?, false
    assert_equal Necromancer.disabled?, true

    subject = Character.create!(name: 'Bob', gold: 100)

    # pickpocket
    assert_equal subject.gold, 99

    subject.destroy!

    # No necromancer
    assert_equal 0, Character.count
    assert_equal 0, Creature.count
  end

end
