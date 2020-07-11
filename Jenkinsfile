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
        stage_map = [:]
        git url: 'https://github.com/PerfectoMobileSA/Perfecto_Gradle'
        wantToDeployDef.each { key, val ->
            stage_map.put(
                'packBuild-' +key, 
                {
                    if(val == 'no') {
                        echo 'skipping stage...'
                        Utils.markStageSkippedForConditional('packBuild-' +key)
                    } else {
                        sh "ls ${tool 'gradle_6.4.1'}/bin/gradle --version -Dorg.gradle.java.home=${tool 'java_11'}"
                        //sh "${tool 'gradle_6.4.1'}/bin/gradle --version"
                        //sh "which java"
                        //sh "gradle --version"
                    }

                }
            ); 
        } 
    stage_map.put('test-2', {echo 'test2'})
    return stage_map
    }
    def createStagesMAVEN(wantToDeployDef, stage_map) {
        stage_map = [:]
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
            choice(choices: ['uat' , 'lt', 'prod'], description: 'Select Environment', name: 'ENVIRONMENT'),
            //maven build
            string(defaultValue: "bKash-customerapp-mw", description: 'MW Repo:', name: 'MWREPO'),
            choice(name: 'deployoperations', choices: ['yes' , 'no'], description: 'Do you want create ami for operations?'),
            choice(name: 'deploytransaction', choices: ['yes' , 'no'], description: 'Do you want create ami for transaction?'),
            //gradle build
            choice(name: 'deploymentbankmw', choices: ['yes' , 'no'], description: 'Do you want create ami for bkash-to-bank-mw?')
        ])
    ])
    //def userInput = input(id: 'userInput', message: 'ENV?',
    //parameters: [[$class: 'ChoiceParameterDefinition', description:'Select ENV to deploy', name:'nameChoice', choices: "UAT\nProd"]
    //])
    def wantToDeploy = [
	    'operations' : deployoperations,
	    'transaction' : deploytransaction,
        'deploymentbankmw' : deploymentbankmw
	]
    //println(userInput); 

    stage('test') {
        parallel(createStages(wantToDeploy))
    }
    stage('Build') {
        sh "echo 'aaa'"
    }
    stage ('Maven Build') {
        parallel(
            "MAVEN":{
                if(wantToDeploy["deployoperations"] == 'yes' || wantToDeploy["deploytransaction"] == 'yes'){
                    stage_map = createStagesMAVEN(wantToDeploy,stage_map)
                }
                stage_map
            },
            "GRADLE":{
                if(wantToDeploy["deploymentbankmw"] == 'yes'){
                    stage_map = createStagesGRADLE(wantToDeploy,stage_map)
                }
                stage_map
            }
        )
    }
}



