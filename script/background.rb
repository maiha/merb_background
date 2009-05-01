#!/usr/bin/env ruby

require 'rubygems'
require 'merb-core'

require File.dirname(__FILE__) + "/../../../config/init"
init_env = ENV['MERB_ENV'] || 'development'
Merb.start_environment(:environment => init_env, :adapter => 'runner')

Signal.trap("TERM") { exit }

# logger.info("MerbBackground: Starting daemon (bonus features #{Job.included_modules.include?(Job::BonusFeatures) ? "enabled" : "disabled"}).")

MerbBackground::Job.execute!
