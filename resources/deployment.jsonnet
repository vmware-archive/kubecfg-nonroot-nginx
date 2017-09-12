local k = import "../.ksonnet-lib/ksonnet.beta.1/k.libsonnet";
local deployment = k.apps.v1beta1.deployment;

# Generate the deployment
{
  generate(name, namespace, container, replicas)::
    deployment.default(name, container, namespace) +
    deployment.mixin.spec.template({
      metadata: {
        labels: {
          app: name
        },
      },
    }) +
    deployment.mixin.spec.replicas(replicas) 
}
