pipeline {
    agent none
    node {
        stage('Parallel Stage') {
            parallel {
                stage('Stage 1') {
                    steps {
                        echo "Stage 1"
                    }
                }
                stage('Stage 2') {
                    steps {
                        script {
                            parallel (
                               def a = "1"
                               if (a == "1") {
                                    "Stage 2.1.": {
                                    echo "Stage 2.1."
                                    },
                                    "Stage 2.2.": {
                                        echo "Stage 2.2."
                                    }
                                }
                            )
                        }
                    }
                }
            }
        }
    }
} 