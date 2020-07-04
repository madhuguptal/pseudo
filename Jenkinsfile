pipeline {
    agent any
    stages {
        stage("Image Build & Deploy to ECR") {
            stage("to ECR") {
                steps {
                    sh "ansible-playbook ansible/image_build.yaml -e workspace=${workspace} -e module=authentication -e env=${params.ENVIRONMENT}"
                }
            }
        }
    }
}