def f() {
   return [2, 3]
}
 
(a, b) = f()
pipeline {
    agent any
    stages {
        stage("to ECR") {
            steps {
                script {
                    println a
                    println b
                }
                sh "ansible-playbook ansible/image_build.yaml -e workspace=${workspace} -e module=hello -e env=sit"
        	}
        }
        stage("to K8S") {
            steps {
                sh "ansible-playbook ansible/toK8S.yaml -e workspace=${workspace} -e module=hello -e env=sit"
        	}
        }
    }
}