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
                        dir('test'){
                            git (url: "https://github.com/amir-hossain-project/hello-world-java.git",branch: 'master')
                            sh "pwd"
                            sh "ls -alh"
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
    }
}