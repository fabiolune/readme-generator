# Test chart

Chart used by the CI to test readme-generator.

## Parameters

### Global parameters

| Name           | Description                  | Value |
| -------------- | ---------------------------- | ----- |
| `replicaCount` | Number of replicas to deploy | `1`   |

### Image parameters

| Name               | Description       | Value          |
| ------------------ | ----------------- | -------------- |
| `image.registry`   | Image registry    | `docker.io`    |
| `image.repository` | Image repository  | `nginx`        |
| `image.tag`        | Image tag         | `1.27`         |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |

### Service parameters

| Name           | Description             | Value       |
| -------------- | ----------------------- | ----------- |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port            | `80`        |
