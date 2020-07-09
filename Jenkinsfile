def f() {
   return [2, 3]
}
 
(   a, b) = f()
pipeline {
    agent any
    stages {
        stage("to ECR") {
            parallel {
                stage('p1') {
                    steps {
                        script {
                            print a
                        }
                    }
                }
                stage('p2') {
                    steps {
                        script {
                            sh "echo ff"
                        }
                    }
                }
                stage('p3') {
                    steps {
                        script {
                            sh "echo ff"
                        }
                    }
                }
                stage('p4') {
                    steps {
                        script {
                            sh "echo ff"
                        }
                    }
                }
            }
        }
        stage("to K8S") {
            steps {
                sh "#ansible-playbook ansible/toK8S.yaml -e workspace=${workspace} -e module=hello -e env=sit"
        	}
        }
    }
}