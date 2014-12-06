#!/usr/bin/env ruby

if ENV['MACKEREL_AGENT_PLUGIN_META'] == '1'
  require 'json'

  meta = {
    graphs: {
      storage: {
        label: 'Storage Capacity',
        unit: 'percentage',
        metrics: [
          { name: 'available', label: 'available(%)', stacked: true },
          { name: 'used',      label: 'used(%)',      stacked: true },
        ],
      }
    }
  }

  puts '# mackerel-agent-plugin'
  puts meta.to_json
  exit 0
end

df = `df -k . | grep '/' | awk '{ print $2 " " $3 }'`.strip.split(' ').map(&:to_i)
size, used = *df
puts [ 'storage.used',               used / size.to_f * 100, Time.now.to_i ].join("\t")
puts [ 'storage.available', (size - used) / size.to_f * 100, Time.now.to_i ].join("\t")
