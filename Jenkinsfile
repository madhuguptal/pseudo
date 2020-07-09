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
        script { 
            aa = ["a":"a","b":"b","cc":"df"]
            parallel(createStages(aa)) }
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
            stage('cba') {
                steps {
                    script {
                        sh "echo 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'"
                    }
                }
            }
            stage('1') {
                steps {
                    script {
                        sh "echo 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'"
                    }
                }
            }
            stage('2') {
                steps {
                    script {
                        sh "echo 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'"
                    }
                }
            }
        }
    }
  }
}