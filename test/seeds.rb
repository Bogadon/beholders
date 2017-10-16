ActiveRecord::Schema.define do
  self.verbose = false

  create_table :characters, :force => true do |t|
    t.string :name
    t.integer :gold
  end

  create_table :creatures, :force => true do |t|
    t.string :name
  end
end

class Character < ActiveRecord::Base
  observed_by "Pickpocket"
  observed_by "Necromancer"
end

class Creature < ActiveRecord::Base
end

class Pickpocket < Beholder
  def after_save(subject)
    subject.gold -= 1
  end
end

class Necromancer < Beholder
  def after_commit(subject)
    # rails 5+ has after_destroy_commit
    Creature.create(name: "Undead #{subject.name}") if subject.destroyed?
  end
end
