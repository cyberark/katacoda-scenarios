
Let's centralize the secrets & server info and add them to Conjur

Host 1 IP:
`docker-compose exec client conjur variable values add server/host1/host "[[HOST1_IP]]"`{{execute}}
Host 1 user name:
`docker-compose exec client conjur variable values add server/host1/user "service01"`{{execute}}
Host 1 password:
`docker-compose exec client conjur variable values add server/host1/pass "W/4m=cS6QSZSc*nd"`{{execute}}

Host 2 IP:
`docker-compose exec client conjur variable values add server/host2/host "[[HOST2_IP]]"`{{execute}}
Host 2 user name:
`docker-compose exec client conjur variable values add server/host2/user "service02"`{{execute}}
Host 2 password:
`docker-compose exec client conjur variable values add server/host2/pass "5;LF+J4Rfqds:DZ8"`{{execute}}
