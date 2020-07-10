


node {
    def mvnHome = [a: 1, b: 2]
    def userInput = input(id: 'userInput', message: 'ENV?',
    parameters: [[$class: 'ChoiceParameterDefinition', defaultValue: 'NULL', 
        description:'Select ENV to deploy', name:'nameChoice', choices: "UAT\nProd"]
    ])
    def wantToDeploy = [
	    'module1' : 'yes',
	    'module2' : 'no',
	    '0000FF' : 'no',
	    'FFFF00' : 'yes'
	]
    println(userInput); 
    def createStages(wantToDeployDef) {
        stage_map = [:]
        wantToDeploy.each { key, val ->
            stage_map.put(
                'packBuild-' +key, 
                {
                    sh "#packer build -var-file variable.json -var 'Version=halum}' ${val}.json"
                }
            ); 
        } 
    stage_map.put('test-2', {echo 'test2'})
    return stage_map
    }

    parallel(createStages(wantToDeploy))
    stage('Checkout') {
        sh "echo 'bb'"
    }

    stage('Build') {
        sh "echo 'aaa'"
    }
}



