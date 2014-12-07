#!/usr/bin/env ruby

require 'json'

if ENV['MACKEREL_AGENT_PLUGIN_META'] == '1'
  meta = {
    graphs: {
      storage: {
        label: 'nasne',
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

nasne_host = ENV['LOCAL_NASNE_HOST'] || '192.168.2.100'
data = JSON.parse `curl -s 'http://#{nasne_host}:64210/status/HDDInfoGet?id=0'`

size, used = data['HDD'].values_at('totalVolumeSize', 'usedVolumeSize')
puts [ 'storage.used',               used / size.to_f * 100, Time.now.to_i ].join("\t")
puts [ 'storage.available', (size - used) / size.to_f * 100, Time.now.to_i ].join("\t")
