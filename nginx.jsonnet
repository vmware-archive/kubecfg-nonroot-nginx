# Defines the all the required parts to run the project in Kubernetes

# Ksonnet
local k = import ".ksonnet-lib/ksonnet.beta.1/k.libsonnet";

# ========================
#  Configuration params
# ========================
local name = "nonroot-nginx";
local namespace = "default";
local image = "bitnami/nginx:1.12.1-r2";
local replicas = 1;
local ports = [
  {
    name: "http",
    port: 8080,
  },
];
local svcports = [
  {
    name: "http",
    port: 80,
  },
];

# ========================
#  Construct the resources
# ========================

# Generators
local svcGen = import "./resources/svc.jsonnet";
local containerGen = import "./resources/container.jsonnet";
local deploymentGen = import "./resources/deployment.jsonnet";

// Generate the service
local svc = svcGen.generate(name, namespace, svcports);
// Generate the container
local container = containerGen.generate(name, image, ports);
// Generate the deployment
local deployment = deploymentGen.generate(name, namespace, container, replicas);

# ========================
#  Generate the list of resources
# ========================
{
  apiVersion: "v1",
  kind: "List",
  items: [
    k.util.prune(deployment),
    k.util.prune(svc),
  ],
}
