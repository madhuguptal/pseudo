def releaseResources() {
    echo "Releasing resources"
    sleep 10
}

pipeline {
    agent any
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
                    script { sleep 20 }
                    echo "remove lock"
                }
            }
        }
    }
}