mackerel-config
===

This is my settings & scripts to collect custom metrics for [mackerel.io](https://mackerel.io/)


## directory

```
/etc/mackerel-agent/
  ├ conf.d/              : out of version controlled, put config file including apikey
  ├ mackerel-agent.conf -> symlink to ./mackerel_agent.conf
  └ scripts/            -> symlink to ./scripts/ for easy reference from config
```