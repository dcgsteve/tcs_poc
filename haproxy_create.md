# HAProxy.cfg create

*NB. To restart, potentially use this command inside the container?*
`haproxy -W -db -f /usr/local/etc/haproxy/haproxy.cfg -sf $(cat /var/run/haproxy.pid)`

## global
```
global 
  chroot /var/lib/haproxy
  user haproxy
  group haproxy
  maxconn 4000
  pidfile /var/run/haproxy.pid
  stats socket /var/lib/haproxy/stats
```

## defaults
```
defaults 
  mode http
  maxconn 3000
  log global
  option httplog
  option redispatch
  option dontlognull
  option http-server-close
  option forwardfor
  timeout http-request 10s
  timeout check 10s
  timeout connect 10s
  timeout client 1m
  timeout queue 1m
  timeout server 1m
  timeout http-keep-alive 10s
  retries 3
```

## stats (optional - presume not on production)
```
frontend stats 
  bind *:8404
  stats enable
  stats uri /
  stats refresh 2s
  stats admin if LOCALHOST
```

## loop for each customer backend ...
```
backend dev 
  mode http
  balance roundrobin
  option httpchk HEAD /
  server dev1 192.168.15.194:80 check rise 1 fall 1
```

## frontend - main (PoC is just http, next phase is to integrate SSL)
```
frontend main 
  bind *:80
  option forwardfor header X-Real-IP
```

## frontend - projects
*Loop for each project; add in definitions for project endpoint(s)*
```
  acl project_a_endpoint src 192.168.15.193
```

## frontend - customer
*Loop for each customer endpoint; add in definition with URL(s)*
```
  acl customer_endpoint1 hdr_dom(host) -i webdev.poc
  acl customer_endpoint2 hdr_dom(host) -i webprod.poc
```

## frontend - logic
*Add in business logic for which project can access which endpoint(s)*
```
  use_backend dev if project_a_endpoint customer_endpoint1
  use_backend prod if project_a_endpoint customer_endpoint2
```
