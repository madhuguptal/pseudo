pipeline {
    agent any
    stages {
        stage("to ECR") {
            steps {
                sh "ansible-playbook ansible/image_build.yaml -e workspace=${workspace} -e module=hello -e env=sit"
        	}
        }
    }
}