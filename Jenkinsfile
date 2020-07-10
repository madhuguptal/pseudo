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
    def createStagesMAVEN(wantToDeployDef, stage_map) {
        git url: 'https://github.com/cyrille-leclerc/multi-module-maven-project'
        withMaven(
            // Maven installation declared in the Jenkins "Global Tool Configuration"
            maven: 'maven_3.6.3',
            jdk: 'java_11'
            // Maven settings.xml file defined with the Jenkins Config File Provider Plugin
            // We recommend to define Maven settings.xml globally at the folder level using
            // navigating to the folder configuration in the section "Pipeline Maven Configuration / Override global Maven configuration"
            // or globally to the entire master navigating to  "Manage Jenkins / Global Tools Configuration"
        ){
            // Run the maven build
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
            booleanParam(name: 'DEPLOY_SHA', defaultValue: false),
            string(name: 'submodule', defaultValue: ''),
            string(name: 'submodule_branch', defaultValue: ''),
            string(name: 'commit_sha', defaultValue: ''),
            choice(choices: ['uat' , 'lt', 'prod'], description: 'Select Environment', name: 'ENVIRONMENT'),
            //maven build
            string(defaultValue: "bKash-customerapp-mw", description: 'MW Repo:', name: 'MWREPO'),
            choice(name: 'deployoperations', choices: ['yes' , 'no'], description: 'Do you want create ami for operations?'),
            choice(name: 'deploytransaction', choices: ['yes' , 'no'], description: 'Do you want create ami for transaction?')
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
        if(deployoperations == 'yes' || deploytransaction == 'yes'){
            stages_mvn = createStagesMAVEN(wantToDeploy,stage_map)
            parallel(stages_mvn)
        }
    }
    //stage ('Build') {
    //    script {
    //        if (ENVIRONMENT == 'prod') {
    //            git url: 'https://github.com/cyrille-leclerc/multi-module-maven-project'
    //            withMaven(
    //                // Maven installation declared in the Jenkins "Global Tool Configuration"
    //                maven: 'maven_3.6.3',
    //                jdk: 'java_11'
    //                // Maven settings.xml file defined with the Jenkins Config File Provider Plugin
    //                // We recommend to define Maven settings.xml globally at the folder level using
    //                // navigating to the folder configuration in the section "Pipeline Maven Configuration / Override global Maven configuration"
    //                // or globally to the entire master navigating to  "Manage Jenkins / Global Tools Configuration"
    //            ){
    //            // Run the maven build
    //            sh "mvn clean verify"

    //            } // withMaven will discover the generated Maven artifacts, JUnit Surefire & FailSafe & FindBugs & SpotBugs reports...
    //        }
    //        if (ENVIRONMENT == 'uat') {
    //            sh "echo 'uat'"
    //        }
    //        if (ENVIRONMENT == 'lt') {
    //            sh "echo 'lt'"
    //        }
    //    }
    //}
    stage ('Maven Build - what if we skip') {
        sh "echo 'it would work'"
    }
}



