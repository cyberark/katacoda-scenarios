# Building out the Java Client API

In this section, we will set up our Katacoda environment by running minikube, and then executing a script file which builds our Java Client API jar using a Dockerfile.

1. Wait for the Katacoda environment to load in all necessary files

   `ls
   `{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
     ```
Desktop  helm-v3.2.1-linux-amd64.tar.gz  java-client-api  kubernetes-install  linux-amd64
     ```
   </details>

<!-- 2. Start minikube

   `minikube start
   `{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
     ```
 * minikube v1.8.1 on Ubuntu 18.04
 * Using the none driver based on user configuration
 * Running on localhost (CPUs=2, Memory=2460MB, Disk=145651MB) ...
 * OS release is Ubuntu 18.04.4 LTS
 * Preparing Kubernetes v1.17.3 on Docker 19.03.6 ...
      - kubelet.resolv-conf=/run/systemd/resolve/resolv.conf
 * Launching Kubernetes ...
 * Enabling addons: default-storageclass, storage-provisioner
 * Configuring local host environment ...
 * Waiting for cluster to come online ...
 * Done! kubectl is now configured to use "minikube"
     ```
   </details> -->

1. Run the build script to build the Conjur Java Client API.

   We have built a Dockerfile to create the Java Client Jar for you.

   `
cd java-client-api
./build.sh
   `{{execute}}

   <details>
     <summary>The build script should end in the following lines...</summary>
     ```
Successfully built cea0c911b9df
Successfully tagged conjur-java-client:latest
conjur-java-client                              latest              cea0c911b9df        Less than a second ago   56
     ```
   </details>
