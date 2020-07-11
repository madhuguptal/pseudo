import org.jenkinsci.plugins.pipeline.modeldefinition.Utils
    def createStageAsWanted(stageName, loopKey, loopValue, cmd) {
         stage_map.put(
                stageName + loopKey,
                {
                    if(loopValue == 'no'){
                        Utils.markStageSkippedForConditional(stageName + loopKey)  
                        echo 'skipping stage...'                        
                    } else {
                        sh "${cmd}"
                    }
                }
            );
        return stage_map
    }


    def RecycleEc2(wantToDeployDef, stage_map) {
        wantToDeployDef.each { key, val ->
           createStageAsWanted("TerminateEc2", key, val, "echo '${ENVIRONMENT}-capp-${val}'")
        }
    return stage_map
    }
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
    return stage_map
    }
node {
    properties([
        parameters([
            choice(choices: ['UAT' , 'LT', 'PROD'], description: 'Select Environment', name: 'ENVIRONMENT'),
            //maven build
            string(defaultValue: "bKash-customerapp-mw", description: 'MW Repo:', name: 'MWREPO'),
            choice(name: 'deployoperations', choices: ['yes' , 'no'], description: 'Do you want create ami for operations?'),
            choice(name: 'deploytransaction', choices: ['yes' , 'no'], description: 'Do you want create ami for transaction?'),
            //gradle build
            choice(name: 'deploymentbankmw', choices: ['yes' , 'no'], description: 'Do you want create ami for bkash-to-bank-mw?')
        ])
    ])
    def wantToDeployMVN = [
	    'deployoperations' : deployoperations,
	    'deploytransaction' : deploytransaction
	]
    def wantToDeployGRD = [
        'deploymentbankmw' : deploymentbankmw,
        'gwMOD1': 'no'
	]
    def unionWantToDeply = wantToDeployMVN + wantToDeployGRD
    stage('test') {
        parallel(createStages(unionWantToDeply))
        sh "echo 'test stg'"
    }

    stage('Build') {
        sh "echo 'aaa'"
    }
    stage ('Code Build') {
        parallel(
            maven: {
                stage_map = [:]
                need_this_stage = 0
                if(wantToDeployMVN["deployoperations"] == 'yes' || wantToDeployMVN["deploytransaction"] == 'yes'){
                    stage_map = createStagesMAVEN(wantToDeployMVN,stage_map)
                    need_this_stage = 1
                }
                if(need_this_stage == 1){
                    parallel(stage_map)
                }
            },
            gradle: {
                stage_map = [:]
                need_this_stage = 0
                if(wantToDeployGRD["deploymentbankmw"] == 'yes' ){
                    stage_map = createStagesGRADLE(wantToDeployGRD,stage_map)
                    need_this_stage = 1
                }
                if(need_this_stage == 1){
                    parallel(stage_map)
                }
            }
        )
    }
    stage ('Maven Build - what if we skip') {
        sh "echo 'it would work'" 
    }
    stage('ReCycle') {
        stage_map = [:]
        need_this_stage = 0
        if(wantToDeployMVN.containsValue('yes') && ENVIRONMENT == 'PROD'){
            stage_map = RecycleEc2(wantToDeployMVN, stage_map)
            need_this_stage = 1
        }
        if(wantToDeployGRD["deploymentbankmw"] == 'yes' && ENVIRONMENT == 'PROD'){
            stage_map = RecycleEc2(wantToDeployGRD, stage_map)
            need_this_stage = 1
        }
        if(need_this_stage == 1){
            parallel(stage_map)
        }
    }
}



