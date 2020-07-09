def createStages(input1) {
  stage_map = [:]
  stage_map.put(
    'test-1', 
    {
      sh 'echo ${IBRNCH}'
    }
    )
  stage_map.put('test-2', {echo 'test2'})
  return stage_map
}

pipeline {
  agent any
  stages {
    stage('test') {
      steps{
        script { parallel(createStages([1,2])) }
      }
    }
  }
}