Now we will deploy a PostgreSQL backend to be used by our demo application. We
can easily deploy Postgres using
[bitnami's Helm chart library](https://github.com/bitnami/charts/tree/master/bitnami/postgresql).

First, add bitnami's Helm chart repo:

```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```{{execute}}

Deploy Postgres to `quickstart-namespace`:

```
helm install pg-backend bitnami/postgresql -n quickstart-namespace --wait --timeout "5m0s" \
  --set image.repository="postgres" \
  --set image.tag="9.6" \
  --set fullnameOverride="pg-backend" \
  --set postgresqlDatabase="pg_backend" \
  --set postgresqlUsername="quickstartUser" \
  --set postgresqlPassword="MySecr3tP@ssword"
```{{execute}}
