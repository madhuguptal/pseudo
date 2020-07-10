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
                        sh "echo '#packer build -var-file variable.json -var Version=halum} ${val}.json'"
                    }
                }
            ); 
        } 
    return stage_map
    }
    def createStagesGRADLE(wantToDeployDef, stage_map) {
        git url: https://github.com/PerfectoMobileSA/Perfecto_Gradle
        withGradle(
            gradle: 'Gradle_6.1.1',
            jdk: 'java_11'
        ){
            sh "gradle version"
        }
        wantToDeployDef.each { key, val ->
            stage_map.put(
                'packBuild-' +key, 
                {
                    if(val == 'no') {
                        echo 'skipping stage...'
                        Utils.markStageSkippedForConditional('packBuild-' +key)
                    } else {
                        //sh "ls ${tool 'Gradle_6.1.1'}/bin/"
                        sh "gradle version"
                    }

                }
            ); 
        } 
    stage_map.put('test-2', {echo 'test2'})
    return stage_map
    }
def createStagesMAVEN(wantToDeployDef, stage_map) {
        git url: 'https://github.com/cyrille-leclerc/multi-module-maven-project'
        withMaven(
            maven: 'maven_3.6.3',
            jdk: 'java_11'
        ){
            sh "mvn clean verify"
        } // withMaven will discover the generated Maven artifacts, JUnit Surefire & FailSafe & FindBugs & SpotBugs reports...
        wantToDeployDef.each { key, val ->
            stage_map.put(
                'packBuild-' +key, 
                {
                    if(val == 'no') {
                        echo 'skipping stage...'
                        Utils.markStageSkippedForConditional('packBuild-' +key)
                    } else {
                        sh "echo '#cp /${val}/target/${val}-0.0.1-SNAPSHOT.war /ansible/${val}.war'"
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
            string(name: 'submodule', defaultValue: ''),
            choice(choices: ['uat' , 'lt', 'prod'], description: 'Select Environment', name: 'ENVIRONMENT'),
            //maven build
            string(defaultValue: "bKash-customerapp-mw", description: 'MW Repo:', name: 'MWREPO'),
            choice(name: 'deployoperations', choices: ['yes' , 'no'], description: 'Do you want create ami for operations?'),
            choice(name: 'deploytransaction', choices: ['yes' , 'no'], description: 'Do you want create ami for transaction?'),
            //gradle build
            choice(name: 'deploymentbankmw', choices: ['yes' , 'no'], description: 'Do you want create ami for bkash-to-bank-mw?')
        ])
    ])
    def mvnHome = [a: 1, b: 2]
    //def userInput = input(id: 'userInput', message: 'ENV?',
    //parameters: [[$class: 'ChoiceParameterDefinition', description:'Select ENV to deploy', name:'nameChoice', choices: "UAT\nProd"]
    //])
    def wantToDeploy = [
	    'operations' : deployoperations,
	    'transaction' : deploytransaction
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
    stage ('Maven Build') {
        stage_map = [:]     
        need_this_stage = 0
        if(deployoperations == 'yes' || deploytransaction == 'yes'){
            stage_map = createStagesMAVEN(wantToDeploy,stage_map)
            need_this_stage = 1
            
        }
        if(deploymentbankmw == 'yes' ){
            def wantToDeployGR = [
                'deploymentbankmw' : deploymentbankmw
            ]
            stage_map = createStagesGRADLE(wantToDeployGR,stage_map)
            need_this_stage = 1
        }
        if(need_this_stage == 1){
            parallel(stage_map)
        }
    }
    stage ('Maven Build - what if we skip') {
        sh "echo 'it would work'"
    }
}



