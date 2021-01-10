# ecs-api

This template provisions ECS service/task, ALB, API Gateway (optional), EFS (optional),
Scaling Policy, Alarms, and Logging for your app.

## Dependency between components

[ecs-iac](https://github.com/microservices-today/ecs-iac) ->
[ecs-cicd](https://github.com/microservices-today/ecs-cicd) ->
[ecs-api](https://github.com/microservices-today/ecs-api) ->
your app (e.g [ngp-nodejs](https://github.com/microservices-today/ngp-nodejs))
