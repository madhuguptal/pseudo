import org.jenkinsci.plugins.pipeline.modeldefinition.Utils
    def createStages(wantToDeployDef) {
        stage_map = [:]
        wantToDeployDef.each { key, val ->
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
    properties([
        parameters([
            booleanParam(name: 'DEPLOY_SHA', defaultValue: false),
            string(name: 'submodule', defaultValue: ''),
            string(name: 'submodule_branch', defaultValue: ''),
            string(name: 'commit_sha', defaultValue: ''),
            choice(choices: ['uat' , 'lt', 'prod'], description: 'Select Environment', name: 'ENVIRONMENT'),
        ])
    ])
    def mvnHome = [a: 1, b: 2]
    //def userInput = input(id: 'userInput', message: 'ENV?',
    //parameters: [[$class: 'ChoiceParameterDefinition', description:'Select ENV to deploy', name:'nameChoice', choices: "UAT\nProd"]
    //])
    def wantToDeploy = [
	    'module1' : 'yes',
	    'module2' : 'no',
	    'module3' : 'no',
	    'module4' : 'yes'
	]
    //println(userInput); 

    stage('test') {
        parallel(createStages(wantToDeploy))
    }
    stage('Checkout') {
        sh "echo ${submodule}"
    }

    stage('Build') {
        sh "echo 'aaa'"
    }

    stage ('Build') {
        if (parameters.ENVIRONMENT == 'prod')
        git url: 'https://github.com/cyrille-leclerc/multi-module-maven-project'
        withMaven(
            // Maven installation declared in the Jenkins "Global Tool Configuration"
            maven: 'maven_3.6.3',
            // Maven settings.xml file defined with the Jenkins Config File Provider Plugin
            // We recommend to define Maven settings.xml globally at the folder level using 
            // navigating to the folder configuration in the section "Pipeline Maven Configuration / Override global Maven configuration"
            // or globally to the entire master navigating to  "Manage Jenkins / Global Tools Configuration"
            ) {

        // Run the maven build
        sh "mvn clean verify"

        } // withMaven will discover the generated Maven artifacts, JUnit Surefire & FailSafe & FindBugs & SpotBugs reports...
    }
}



