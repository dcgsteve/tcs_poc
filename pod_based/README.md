# Podman specific notes

## Ports <1024
Need to allow rootless pods to be able to bind ports <1024 (I.E. for 80/443)
`echo 0 | sudo tee /proc/sys/net/ipv4/ip_unprivileged_port_start`
