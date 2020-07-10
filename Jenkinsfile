


node {
    def mvnHome = [a: 1, b: 2]

    stage('User Input?') {
        steps {
            script {
                def userInput = input(id: 'userInput', message: 'ENV?',
                parameters: [[$class: 'ChoiceParameterDefinition', defaultValue: 'NULL', 
                    description:'describing choices', name:'nameChoice', choices: "UAT\nPROD\nSIT"]
                ])

                println(userInput); 
            }
        }

    }


    stage('Checkout') {
        sh "echo 'bb'"
    }

    stage('Build') {
        sh "echo 'aaa'"
    }
}