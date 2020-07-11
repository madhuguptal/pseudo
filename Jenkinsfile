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
    def createStagesGRADLE(wantToDeployDef1, stage_map) {
        git url: 'https://github.com/PerfectoMobileSA/Perfecto_Gradle'
        wantToDeployDef1.each { key, val ->
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
    stage_map.put('test-2grd', {echo 'test2'})
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
    stage_map.put('test-2mvn', {echo 'test2'})
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
    //def userInput = input(id: 'userInput', message: 'ENV?',
    //parameters: [[$class: 'ChoiceParameterDefinition', description:'Select ENV to deploy', name:'nameChoice', choices: "UAT\nProd"]
    //])
    def wantToDeployMVN = [
	    'deployoperations' : deployoperations,
	    'deploytransaction' : deploytransaction,
	    'm1': 'yes',
	    'm2': 'no',
	    'm3': 'yes',
	    'm4': 'yes',
	    'm5': 'no',
	    'm6': 'no',
	    'm7': 'no',
	    'm8': 'yes',
	    'm9': 'yes',
	    'm10': 'no',
	    'm11': 'yes',
	    'm12': 'no',
	    'm13': 'no'
	]
    def wantToDeployGRD = [
        'deploymentbankmw' : deploymentbankmw,
        'r23': 'no',
        'r134': 'yes',
        'r24': 'no',
        'r244': 'no',
        'r13': 'yes'
	]

    stage('test') {
        //parallel(createStages(wantToDeployMVN))
        sh "echo 'test stg'"
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
        if(wantToDeployMVN["deployoperations"] == 'yes' || wantToDeployMVN["deploytransaction"] == 'yes'){
            stage_map = createStagesMAVEN(wantToDeployMVN,stage_map)
            need_this_stage = 1
        }
        if(wantToDeployGRD["deploymentbankmw"] == 'yes' ){
            stage_map = createStagesGRADLE(wantToDeployGRD,stage_map)
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



