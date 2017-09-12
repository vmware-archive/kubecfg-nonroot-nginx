# Bitnami non-root Nginx using Kubecfg and Ksonnet

This project includes a template to deploy Bitnami Nginx for Kubernetes or Openshift. 
This is a non-root container, which means that `nginx` process is started as a normal user, and therefore on a port above `1024`. Port `8080` is used by default.

The deployment is composed of  3 resources:

* Container: Defines the Pod, including ports, envs, readinessProbe and livenessProbe 
* Deployment: Defines the Pod deployment, setting number of replicas and metadata 
* Service: Expose the ports of the Pod to the cluster

All the resources are defined in the `resources` folder. The `nginx.jsonnet` file initialize all the required resources and return them in a single YAML file. 

## Components of the project

To use this project, you need to install [jsonnet](https://github.com/google/jsonnet/).

To create the specification file for Kubernetes, we use `ksonnet`. This library provides us some functions to generate the spec for the different resources.

To manage the kubernetes objects we use [kubecfg](https://github.com/ksonnet/kubecfg/), a tool for managing complex enterprise Kubernetes environments as code.

And last but not least, you need to have a working Kuberntes environment.

At the beginning, you may think that it's complicated, but the more complex your infrastructure is, the more you will gain from using kubecfg.

## Installation


To get the ```jsonnet``` CLI tool in MAC with Homebrew do:

```
brew install jsonnet
```
Otherwise (Linux, MAC without homebrew) install from the repo directly:
https://github.com/google/jsonnet

To install ksonnet and run the project, you only need to clone it in this folder:

```
git clone https://github.com/ksonnet/ksonnet-lib.git .ksonnet-lib
```

Finally, install latest kubecfg from the repo:
https://github.com/ksonnet/kubecfg/releases

Now, you're ready to compile the current deployment in order to test your setup:

```
kubecfg show -f nginx.jsonnet
```

## Deployment

Once the software it's installed, you can examine the output file:

```
$ kubecfg show -f nginx.jsonnet 
```

If you want to store the generated YAML, just write the output in a file

```
kubecfg show -f nginx.jsonnet > nginx.yaml
```
or apply it to Kubernetes directly.

```
$ kubecfg apply -f nginx.jsonnet 
```

This will create this Kubernetes resources:

- A deployment called `nonroot-nginx` which listens on port `8080`.
- A pod which is controlled by the above deployment.
- A service that exposes the port as a ClusterIP in the typical HTTP port `80`.

## Making changes 

Let's modify the `nginx.jsonnet` file and change the number of replicas. To do so, modify the line 

```
local replicas = 1; # change this value to 3 
```

Verify changes you've made with:

```
$ kubecfg diff -f nginx.jsonnet
```

Finally, apply the changes with:

```
$ kubecfg apply -f nginx.jsonnet
```

## Delete all created resources 

Use this command to delete the deployment:

```
$ kubecfg delete -f nginx.jsonnet
```
