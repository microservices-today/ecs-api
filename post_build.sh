#!/usr/bin/env bash

set -ex

if [ "$DEPLOY_ENVIRONMENT" = "development" ] || \
   [ "$DEPLOY_ENVIRONMENT" = "staging" ] || \
   [ "$DEPLOY_ENVIRONMENT" = "feature" ] || \
   [ "$DEPLOY_ENVIRONMENT" = "hotfix" ]; then
    # TODO: Remove it and compare with prod. $(aws ecr get-login --registry-ids "${AWS_ACCOUNT_ID}" --region $ECS_REGION)
    echo "test 0"
    aws ecr get-login-password --region ${ECS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${ECS_REGION}.amazonaws.com
    echo "test 1"
    echo ${AWS_ACCOUNT_ID}.dkr.ecr.${ECS_REGION}.amazonaws.com/${ECR_NAME}:$(cat ./docker.tag)
    echo "test 2"
    docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${ECS_REGION}.amazonaws.com/${ECR_NAME}:$(cat ./docker.tag)
    echo "test 3"
elif [ "$DEPLOY_ENVIRONMENT" = "production" ]; then
    $(aws ecr get-login --registry-ids "$SOURCE_AWS_ACCOUNT_ID" --region $SOURCE_AWS_REGION)
    docker pull ${SOURCE_AWS_ACCOUNT_ID}.dkr.ecr.${SOURCE_AWS_REGION}.amazonaws.com/${ECR_NAME}:$(cat ./stage.tag)
    docker tag ${SOURCE_AWS_ACCOUNT_ID}.dkr.ecr.${SOURCE_AWS_REGION}.amazonaws.com/${ECR_NAME}:$(cat ./stage.tag) ${AWS_ACCOUNT_ID}.dkr.ecr.${ECS_REGION}.amazonaws.com/${ECR_NAME}:$(cat ./prod.tag)
    $(aws ecr get-login --registry-ids "${AWS_ACCOUNT_ID}" --region $ECS_REGION)
    docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${ECS_REGION}.amazonaws.com/${ECR_NAME}:$(cat ./prod.tag)
else
    echo "NO POST BUILD ACTIONS IN RELEASE"
fi
echo "test end"
