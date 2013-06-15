# -*- coding: utf-8 -*-

require "SocketIO"
require "yaml"
require 'active_support/core_ext'

@config = YAML.load_file(ARGV[0] || 'config.yml').with_indifferent_access

channel  = @config[:channel]
#saykana  = @config[:saykana]

root_url = "http://screenx.tv"
uri       = URI(root_url)
uri.port  = 8800

puts "ScreenX TV Comment Viewer"
puts "Channel: #{root_url}/#{channel}"
puts ""

name = 'No name'
msg  = 'No message'
client = SocketIO.connect(uri) do
  before_start do
    on_message {|message|
      puts message
    }
    on_event('chat'){ |data|
      name = data.first['name']
      msg  = data.first['message']
      puts "@#{name}: #{msg}"
      # `saykana -s 100 #{msg}` if saykana
    }
    on_event('viewer'){ |data|
      puts "Viewer: #{data.first['viewer']}"
    }
    on_disconnect {puts "I GOT A DISCONNECT"}
  end

  after_start do
    emit("init", {channel: channel})
  end
end


loop do
  sleep 10
end
