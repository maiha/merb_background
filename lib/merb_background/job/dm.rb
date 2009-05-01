require File.dirname(__FILE__) + '/ar2dm'

class MerbBackground::Job
  include DataMapper::Resource

  property :id, Serial
  property :worker_class, String, :size => 255
  property :worker_method, String, :size => 255
  property :args, Yaml
  property :result, Yaml
  property :priority, Integer
  property :progress, Integer
  property :state, String
  property :lock_version, Integer, :default => 0
      
  property :start_at, DateTime
  property :started_at, DateTime

  property :created_at, DateTime
  property :updated_at, DateTime

  before :save, :setup_state
  before :save, :setup_priority
  before :save, :setup_start_at

  validates_present :worker_class, :worker_method

  include DataMapper::ActiveRecordMethods

  def self.ready
    all(:start_at.lte => Time.now)
  end
end

