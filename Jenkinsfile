def releaseResources() {
    echo "Releasing resources"
    sleep 10
}

pipeline {
    agent none
    stages {
        stage("test") {
            steps {
                parallel (
                    unit: {
                        script {
                            echo "Doing steps..."
                            sleep 20
                        }
                    }
                )
            }
            post {
                cleanup {
                    script { ... }
                    sh "remove lock"
                }
            }
        }
    }
}