#!/usr/bin/env ruby

require 'aws-sdk'

ec2 = AWS::EC2.new(:region => "us-west-2", 
                   :access_key_id => 'AKIAJBWOCAUE2S2DINAQ',
                   :secret_access_key => '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')

key_pair = ec2.key_pairs.create(ARGV[0])                                                   
File.open("../private/" + ARGV[0] + ".pem", "wb") do |f|
  f.write(key_pair.private_key)
end
