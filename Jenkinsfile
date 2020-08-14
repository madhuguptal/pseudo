pipeline {
    agent any
    parameters {
        choice(choices: ['uat' , 'lt', 'prod'], description: 'Select Environment', name: 'ENVIRONMENT')
    }
    stage("AUTH") {
        steps {
            dir("infra") {
                sh "echo ${params.ENVIRONMENT}"
            }
        }
    }

}
