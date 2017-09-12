local k = import "../.ksonnet-lib/ksonnet.beta.1/k.libsonnet";
local service = k.core.v1.service;

# Generate the service
{
  generate(name, namespace, ports)::
    service.default(name, namespace) +
    service.mixin.metadata.labels({
      app: name
    }) +
    service.mixin.spec.type('ClusterIP') +
    service.mixin.spec.ports([
      {
        name: port.name,
        port: port.port,
        targetPort: port.name
      }
      for port in ports
    ]) +
    service.mixin.spec.selector({
      app: name
    })
}
