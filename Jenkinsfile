pipeline {
    agent any
    parameters {
        choice(choices: ['uat' , 'lt', 'prod'], description: 'Select Environment', name: 'ENVIRONMENT')
    }
    stage("stage1") {
        stage("AUTH") {
            steps {
                dir("infra") {
                    sh "echo ${params.ENVIRONMENT}"
                }
            }
        }
    }
}
