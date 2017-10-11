# frozen_string_literal: true

class Beholder

  def self.inherited(subclass)
    super
    subclass.disabled = subclass.superclass.disabled?
  end

  def self.disable!
    @disabled = true
  end

  def self.enable!
    @disabled = false
  end

  def self.disabled?
    @disabled
  end

  def self.disabled=(value)
    @disabled = value
  end

  def self.self_and_descendants
    [self] + descendants
  end

  def self.enable_all!
    self_and_descendants.each(&:enable!)
  end

  def self.disable_all!
    self_and_descendants.each(&:disable!)
  end

  def self.trigger(action, model)
    return if disabled?
    new.public_send(action, model) if method_defined? action
  end

end

