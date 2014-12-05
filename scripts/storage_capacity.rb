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

used = `df . | grep '/' | awk '{ print $5 }' | sed 's/%//'`.strip.to_i
puts [ 'storage.used',            used, Time.now.to_i ].join("\t")
puts [ 'storage.available', 100 - used, Time.now.to_i ].join("\t")
