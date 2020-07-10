import org.jenkinsci.plugins.pipeline.modeldefinition.Utils
    def createStages(wantToDeployDef) {
        stage_map = [:]
        wantToDeployDef.each { key,  ->
            stage_map.put(
                'packBuild-' +key, 
                {
                    if(val == 'no'){
                        echo 'skipping stage...'
                        Utils.markStageSkippedForConditional('packBuild-' +key)
                    } else {
                        sh "#packer build -var-file variable.json -var 'Version=halum}' ${val}.json"
                    }
                }
            ); 
        } 
    stage_map.put('test-2', {echo 'test2'})
    return stage_map
    }

node {
    def mvnHome = [a: 1, b: 2]
    def userInput = input(id: 'userInput', message: 'ENV?',
    parameters: [[$class: 'ChoiceParameterDefinition', defaultValue: 'NULL', 
        description:'Select ENV to deploy', name:'nameChoice', choices: "UAT\nProd"]
    ])
    def wantToDeploy = [
	    'module1' : 'yes',
	    'module2' : 'no',
	    'module3' : 'no',
	    'module4' : 'yes'
	]
    println(userInput); 

    stage('test') {
        parallel(createStages(wantToDeploy))
    }
    stage('Checkout') {
        sh "echo 'bb'"
    }

    stage('Build') {
        sh "echo 'aaa'"
    }
}



