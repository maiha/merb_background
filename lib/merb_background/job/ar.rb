class MerbBackground::Job < ActiveRecord::Base
  cattr_accessor :states
  self.states = %w(pending running finished failed)

  serialize :args, Array
  serialize :result

  before_create :setup_state, :setup_priority, :setup_start_at
  validates_presence_of :worker_class, :worker_method
end
