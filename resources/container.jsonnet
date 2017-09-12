local k = import "../.ksonnet-lib/ksonnet.beta.1/k.libsonnet";
local container = k.core.v1.container;

# Generate the Container
{
  generate(name, image, ports)::
    container.default("nginx", image) +
    container.env([]) +
    container.ports([
      {
        name: port.name,
        containerPort: port.port
      }
      for port in ports
    ]) +
    container.mixin.readinessProbe.httpGet({
      path: "/",
      port: "http",
    }) +
    container.mixin.readinessProbe.initialDelaySeconds(30) +
    container.mixin.readinessProbe.timeoutSeconds(3) +
    container.mixin.readinessProbe.periodSeconds(5) +
    container.mixin.livenessProbe.httpGet({
      path: "/",
      port: "http"
    }) +
    container.mixin.livenessProbe.initialDelaySeconds(60) +
    container.mixin.livenessProbe.timeoutSeconds(5) +
    container.mixin.livenessProbe.periodSeconds(6) 
}
