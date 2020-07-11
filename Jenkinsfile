pipeline {
    agent any
    stages {
        stage('Stage 1') { steps {pwd()}}
        stage('Stage 2') { steps {pwd()}}
        stage('Stages 3 & 4 in parallel') {
            parallel {
                stage('Stage 3') { steps {pwd()}}
                stage('Stage 4') {
                    stages {
                        stage('Stage 4a') { steps {pwd()}}
                        stage('Stage 4b') { steps {pwd()}}
                    }
                }
            }
        }
    }
}