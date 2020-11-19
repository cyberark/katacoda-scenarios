![application developer](https://secretless.io/img/application_developer.jpg)
## You are now the application developer

Let's have another set of environment variables, which does NOT contain any secrets for the developer.
To review it, execute: `cat ./secretless/developer-env.sh`{{execute HOST1}}

Now let's create the yaml file to deploy the app with secretless broker.

```
. ./secretless/developer-env.sh

cat << EOL > secretless/testapp-secure.yml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: testapp-secure-sa
  namespace: testapp
---
apiVersion: v1
kind: Service
metadata:
  name: testapp-secure
  namespace: testapp
spec:
  type: NodePort
  ports:
  - port: 8080
    targetPort: 8080
  selector:
    app: testapp-secure
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: "${APP_NAME}"
  name: "${APP_NAME}"
  namespace: "${APP_NAMESPACE}"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: "${APP_NAME}"
  template:
    metadata:
      labels:
        app: "${APP_NAME}"
    spec:
      serviceAccountName: "${APP_SERVICE_ACCOUNT_NAME}"
      hostAliases:
      - ip: "10.105.68.126"
        hostnames:
        - "conjur.demo.com"

      containers:
      - image: cyberark/demo-app
        imagePullPolicy: IfNotPresent
        name: testapp-secure
        ports:
        - containerPort: 8080
        env:
          - name: DB_URL
            value: postgresql://localhost:5432/postgres
          - name: DB_USERNAME
            value: dummy
          - name: DB_PASSWORD
            value: dummy
          - name: DB_PLATFORM
            value: postgres
      - name: secretless
        image: cyberark/secretless-broker:latest
        imagePullPolicy: Always
        args: ["-f", "/etc/secretless/secretless.yml"]
        env:
          - name: MY_POD_NAME
            valueFrom:
              fieldRef:
                fieldPath: metadata.name
          - name: MY_POD_NAMESPACE
            valueFrom:
              fieldRef:
                fieldPath: metadata.namespace
          - name: MY_POD_IP
            valueFrom:
              fieldRef:
                fieldPath: status.podIP

          - name: CONJUR_APPLIANCE_URL
            value: "${CONJUR_APPLIANCE_URL}"
          - name: CONJUR_AUTHN_URL
            value: "${CONJUR_APPLIANCE_URL}/authn-k8s/${AUTHENTICATOR_ID}"
          - name: CONJUR_ACCOUNT
            value: "${CONJUR_ACCOUNT}"
          - name: CONJUR_AUTHN_LOGIN
            value: "host/conjur/authn-k8s/${AUTHENTICATOR_ID}/apps/service-account-based-app"
          - name: CONJUR_SSL_CERTIFICATE
            valueFrom:
              configMapKeyRef:
                name: conjur-cert
                key: ssl-certificate
        readinessProbe:
          httpGet:
            path: /ready
            port: 5335
          initialDelaySeconds: 10
          periodSeconds: 5
          timeoutSeconds: 2
          failureThreshold: 60
        volumeMounts:
          - mountPath: /etc/secretless
            name: config
            readOnly: true
      volumes:
        - name: config
          configMap:
            name: secretless-config
            defaultMode: 420
EOL
```{{execute HOST1}}

After generating the application manifest, deploy the application by running:
```
kubectl apply -f secretless/testapp-secure.yml
```{{execute HOST1}}
