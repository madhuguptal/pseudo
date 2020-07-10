


node {
    def mvnHome = [a: 1, b: 2]
    def userInput = input(id: 'userInput', message: 'ENV?',
    parameters: [[$class: 'ChoiceParameterDefinition', defaultValue: 'NULL', 
        description:'input choise', name:'nameChoice', choices: "UAT\nProd"]
    ])

    println(userInput); 



    stage('Checkout') {
        sh "echo 'bb'"
    }

    stage('Build') {
        sh "echo 'aaa'"
    }
}