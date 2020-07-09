def createStages(input1) {
  stage_map = [:]
  stage_map.put(
    'test-1', 
    {
      print input1
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
        script { parallel(createStages("s")) }
      }
    }
  }
}