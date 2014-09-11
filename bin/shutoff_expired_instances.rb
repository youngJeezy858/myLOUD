#!/usr/bin/env ruby

require File.expand_path('../../config/environment', __FILE__)

Entitlement.all.each do |entitlement|
  if not entitlement.shutoff.nil? and entitlement.shutoff + Time.zone_offset('EST') > Time.now 
    ### AWS KEY REQUIRED ###
    #       instance = AWS::EC2.new.instances[entitlement.instance_id]       
    #       instance.stop
    ### TESTING - NO KEY ###
    puts "#{entitlement.shutoff + Time.zone_offset('EST')}"
    puts "#{Time.now}"
    entitlement.status = "stopped"
    entitlement.shutoff = ""
    ########################
    entitlement.save
  end
  puts "fuck #{entitlement.name}"
end
puts "fuck"

