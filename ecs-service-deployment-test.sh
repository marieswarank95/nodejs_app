#!/bin/bash
SERVICE_NAME="nodejs-service"
IMAGE_VERSION="v_"${BUILD_NUMBER}
TASK_FAMILY="nodejs-app-task-definition"

# Create a new task definition for this build
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" nodejs-app-td.json > nodejs-app-td-v_${BUILD_NUMBER}.json
echo "creating new revision of the task definition"
aws ecs register-task-definition --family nodejs-app-task-definition --cli-input-json file://nodejs-app-td-v_${BUILD_NUMBER}.json

# Update the service with the new task definition and desired count
TEST1=`aws ecs describe-task-definition --task-definition nodejs-app-task-definition`
TEST2=`aws ecs describe-task-definition --task-definition nodejs-app-task-definition | egrep "revision"`
TEST3=`aws ecs describe-task-definition --task-definition nodejs-app-task-definition | egrep "revision" | tr "/" " "`
TEST4=`aws ecs describe-task-definition --task-definition nodejs-app-task-definition | egrep "revision" | tr "/" " " | awk '{print $2}'`
echo ${TEST1}
echo ${TEST2}
echo ${TEST3}
echo ${TEST4}
TASK_REVISION=`aws ecs describe-task-definition --task-definition nodejs-app-task-definition | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
echo "latest task definition revision is ${TASK_REVISION}"
#DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME} | egrep "desiredCount" | tr "/" " " | awk '{print $2}' | sed 's/,$//'`
#if [ ${DESIRED_COUNT} = "0" ]; then
#    DESIRED_COUNT="1"
#fi
echo "updating ${SERVICE_NAME} service"
aws ecs update-service --cluster nodejs-app-cluster --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION}
