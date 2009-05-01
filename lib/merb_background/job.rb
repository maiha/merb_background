# Example:
# 
# job = Job.enqueue!(MyWorker, :my_method, "my_arg_1", "my_arg_2")

#require File.dirname(__FILE__) + '/job/ar.rb'
require File.dirname(__FILE__) + '/job/dm.rb'

class MerbBackground::Job
  cattr_accessor :states
  self.states = %w(pending running finished failed)

#  attr_readonly :worker_class, :worker_method, :args
  
  def self.enqueue!(worker_class, worker_method, *args)
    job = create!(
      :worker_class  => worker_class.to_s,
      :worker_method => worker_method.to_s,
      :args          => args
    )

    logger.info("MerbBackground: Job enqueued. Job(id: #{job.id}, worker: #{worker_class}, method: #{worker_method}, argc: #{args.size}).")
    
    job
  end

  def self.execute!(config = nil)
    config = MerbBackground::Config.merge(config || {})
    cleanup_finished_jobs if config[:cleanup_interval] == :at_start

    config.each do |k,v| 
      logger.info "MerbBackground: #{k}: #{v}"
    end

    loop do
      if job = pending.ready.first(:order => [:priority.desc, :start_at.asc])
        job.get_done!
      else
        logger.info("MerbBackground: Waiting for jobs...")
        sleep config[:monitor_interval]
      end
      cleanup_finished_jobs if config[:cleanup_interval] == :continuous
    end
  end


  # Invoked by a background daemon.
  def get_done!
    initialize_worker
    invoke_worker
  rescue Exception => e
    rescue_worker(e)
  ensure
    ensure_worker
  end
  
  # Restart a failed job.
  def restart!
    if failed? 
      update_attributes!(
        :result     => nil, 
        :progress   => nil, 
        :started_at => nil, 
        :state      => "pending"
      )
      logger.info("MerbBackground: Job restarted. Job(id: #{id}).")
    end
  end
  
  def initialize_worker
    update_attributes!(:started_at => Time.now, :state => "running")
    @worker = worker_class.constantize.new
    logger.info("MerbBackground: Job initialized. Job(id: #{id}).")
  end
  
  def invoke_worker
    self.result = @worker.send(worker_method, *args)
    self.state  = "finished"
    logger.info("MerbBackground: Job finished. Job(id: #{id}).")
  end
  
  def rescue_worker(exception)
    self.result = [exception.message, exception.backtrace.join("\n")].join("\n\n")
    self.state  = "failed"
    logger.info("MerbBackground: Job failed. Job(id: #{id}).")
  end
  
  def ensure_worker
    self.progress = @worker.instance_variable_get("@progress")
    save!
  rescue StaleObjectError
    # Ignore this exception as its only purpose is
    # not allowing multiple daemons execute the same job.
    logger.info("MerbBackground: Race condition handled (It's OK). Job(id: #{id}).")
  end

  # Delete finished jobs that are more than a week old.
  def self.cleanup_finished_jobs
    logger.info "MerbBackground: Cleaning up finished jobs."

    # TODO: AR compats
    Job.finished.all(:updated_at.lt => 1.week.ago).destroy!
  end
  
  def self.generate_state_helpers
    states.each do |state_name|
      define_method("#{state_name}?") do
        state == state_name
      end

      # Job.running => array of running jobs, etc.
      self.class.send(:define_method, state_name) do
        all(:state => state_name, :order => [:id.desc])
      end
    end
  end
  generate_state_helpers

  def setup_state
    return unless state.blank?

    self.state = "pending" 
  end
  
  # Default priority is 0. Jobs will be executed in descending priority order (negative priorities allowed).
  def setup_priority
    return unless priority.blank?
    
    self.priority = 0
  end
  
  # Job will be executed after this timestamp.
  def setup_start_at
    return unless start_at.blank?
    
    self.start_at = Time.now
  end

end  
