
To inject secrets in to appc container when apps starts, we will make use of summon

To use summon, secrets.yaml file is required to specific the env variable list and their corresponding variable path in Conjur:

```
cat <<'EOF' >> secrets.yaml
DB_USERNAME: !var app/testapp/secret/username
DB_PASSWORD: !var app/testapp/secret/password
EOF
```{{execute}}

We will store it as configmap
```
oc create configmap testapp-init-summon-config --from-file=secrets.yaml
```{{execute}}

Next, we will add an init container to the application

```
source secretless/developer-env.sh && cat <<EOF > testapp-init-summon.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: testapp-init-summon
  namespace: testapp
spec:
  type: NodePort
  ports:
  - port: 8080
    targetPort: 8080
  selector:
    app: testapp-init-summon
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: testapp-init-summon
  name: testapp-init-summon
  namespace: testapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: testapp-init-summon
  template:
    metadata:
      labels:
        app: testapp-init-summon
    spec:
      serviceAccountName: testapp-secure-sa
      containers:
      - image: cyberark/demo-app
        imagePullPolicy: IfNotPresent
        name: testapp-init-summon
        ports:
        - containerPort: 8080
        env:
          - name: DB_URL
            value: postgresql://testapp-db.testapp.svc.cluster.local:5432/postgres
          - name: DB_PLATFORM
            value: postgres
          - name: CONJUR_APPLIANCE_URL
            value: "${CONJUR_APPLIANCE_URL}"
          - name: CONJUR_AUTHN_URL
            value: "${CONJUR_APPLIANCE_URL}/authn-k8s/${AUTHENTICATOR_ID}"
          - name: CONJUR_ACCOUNT
            value: "${CONJUR_ACCOUNT}"
          - name: CONJUR_AUTHN_LOGIN
            value: "host/conjur/authn-k8s/${AUTHENTICATOR_ID}/apps/service-account-based-app-using-authenticator"
          - name: CONJUR_SSL_CERTIFICATE
            valueFrom:
              configMapKeyRef:
                name: conjur-cert
                key: ssl-certificate
          - name: CONJUR_AUTHN_TOKEN_FILE
            value: /run/conjur/access-token
        volumeMounts:
          - mountPath: /run/conjur
            name: conjur-access-token
            readOnly: true
          - mountPath: /etc/summon
            name: summon-config
            readOnly: true
        command: [ "summon", "-f", "/etc/summon/secrets.yaml",  "java", "-jar", "/app.jar" ]
      initContainers:
      - image: cyberark/conjur-authn-k8s-client
        imagePullPolicy: IfNotPresent
        name: authenticator
        env:
          - name: CONTAINER_MODE
            value: init
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
            value: "host/conjur/authn-k8s/${AUTHENTICATOR_ID}/apps/service-account-based-app-using-authenticator"
          - name: CONJUR_SSL_CERTIFICATE
            valueFrom:
              configMapKeyRef:
                name: conjur-cert
                key: ssl-certificate
        volumeMounts:
          - mountPath: /run/conjur
            name: conjur-access-token
      volumes:
        - name: conjur-access-token
          emptyDir:
            medium: Memory
        - name: summon-config
          configMap:
            name: testapp-init-summon-config
EOF


We can deploy the app and expose the route:

```
oc apply -f testapp-init-summon.yaml
oc expose service/testapp-init-summon
```{{execute}}


## Test the app

To check whether the app is started & get the endpoint of the service, execute:
```
export URL=$(oc get route testapp-init-summon -o jsonpath='{.spec.host}'  ) && \
curl $URL/pets
```{{execute}}

If a `curl` error is returned, that means the application is still being started.
Please wait for a couple of moments and try again

## Test the app

To add a new message with a random name, execute:
`curl  -d "{\"name\": \"$(shuf -n 1 /usr/share/dict/words)\"}" -H "Content-Type: application/json" $URL/pet`{{execute}}

Now let's list all the messages by executing:
`curl -s $URL/pets | jq .`{{execute}}

You can repeat the above actions to create & review multiple messages.
