


node {
    def mvnHome = [a: 1, b: 2]
    def userInput = input(id: 'userInput', message: 'Merge to?',
    parameters: [[$class: 'ChoiceParameterDefinition', defaultValue: 'strDef', 
        description:'describing choices', name:'nameChoice', choices: "QA\nUAT\nProduction\nDevelop\nMaster"]
    ])

    println(userInput); //Use this value to branch to different logic if needed



    stage('Checkout') {
        sh "echo 'bb'"
    }

    stage('Build') {
        sh "echo 'aaa'"
    }
}