def createStages(input1) {
    stage_map = [:]
    for(int i in input1) { 
        stage_map.put(
            'test-' +i, 
            {
                print i
            }
        ); 
    } 
  stage_map.put('test-2', {echo 'test2'})
  return stage_map
}

pipeline {
  agent any
  stages {
    stage('test') {
      steps{
        script { parallel(createStages(["a","b","c"])) }
      }
    }
    stage('WarmUp') {
        parallel {
            stage('abc') {
                steps {
                    script {
                        sh "echo 'aaa'"
                    }
                }
            }
            stage('abc') {
                steps {
                    script {

                    }
                }
            }

        }
    }
  }
}