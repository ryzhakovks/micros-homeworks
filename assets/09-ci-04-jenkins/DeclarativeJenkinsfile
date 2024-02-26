pipeline {
    agent any
    options {
        skipDefaultCheckout()
    }
    stages {
        stage('Checkout repository') {
            steps {
                dir('vector-role') {
                    checkout scm
                }
            }
        }
        stage('Install molecule') {
            steps {
                sh 'pip3 install molecule==3.4.0 molecule-docker'
                sh 'pip3 install --upgrade requests==2.26.0'
            }
        }
        stage('Test role') {
            steps {
                dir('vector-role') {
                    sh 'molecule test'
                }
            }
        }
    }
}
