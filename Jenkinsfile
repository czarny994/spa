pipeline {
    agent { node { label "linux" } }

    stages {
        stage("Check vagrant") {
            steps {  
                // Check Vagrant version
                echo "============================= Stage Check vagrant ============================="      
                sh 'vagrant --version'
            }
        }
        stage("Check vagrantfile") {
            steps {  
                echo "============================= Stage Check Vagrantfile ============================="     
                // Validate vagrantfile
                sh 'vagrant validate'
            }
        }
        stage("Set up VM") {
            steps {  
                echo "============================= Set up Vagrant Machine ============================="  
                // Set up VM machine
                withEnv(['BUILD_ID=dontKillMe', 'JENKINS_NODE_COOKIE=dontKillMe']) {
                    sh 'vagrant up'
                }
            }
        }
        stage("Lint") {
            steps {  
                echo "============================= ng lint ============================="  
                sh 'vagrant ssh -c "cd /mnt/share; npm install --save-dev @angular-devkit/build-angular"'
                sh 'vagrant ssh -c "cd /mnt/share; ng lint"'
            }
        }
        stage("Unit Test") {
            steps {  
                echo "============================= Execute Unit Tests ============================="  
                // Run unit test
                sh 'vagrant ssh -c "cd /mnt/share; ng test --watch=false"'
            }
        }
        stage("E2E Test") {
            steps {  
                echo "============================= Execute E2E Tests ============================="  
                // Run E2E Tests
                sh 'vagrant ssh -c "cd /mnt/share; ng e2e"'
            }
        }
        stage("DOCKER deliveery") {
            steps {  
                withCredentials([
                        usernamePassword(credentialsId: 'a9a0df0c-944f-4e74-a5df-52a2c65b3688',
                        passwordVariable: 'DOCKER_PASS',
                        usernameVariable: 'DOCKER_USER')
                        ]) {
                    echo "============================= LOGIN =============================" 
                        sh 'vagrant ssh -c "sudo docker login -u=$DOCKER_USER -p=$DOCKER_PASS"'
                    }

                withCredentials([string(credentialsId: 'DockerHubRepository', variable: 'SECRET')])
                {
                    echo "============================= BUILD =============================" 
                    sh 'vagrant ssh -c "cd /mnt/share; sudo docker build -t $SECRET:${BUILD_NUMBER} ."'
                    echo "============================= PUSH  ============================="
                    sh 'vagrant ssh -c "sudo docker push $SECRET:${BUILD_NUMBER}"'
                }
            }
        }
        stage("Deploy") {
            steps {  
                withCredentials([string(credentialsId: 'DockerHubRepository', variable: 'SECRET')])
                {
                    echo "============================= Deploy ============================="  
                    sh "sudo docker pull $SECRET:${BUILD_NUMBER}"
                    sh "sudo docker run -d -p 80:80 --name app $SECRET:${BUILD_NUMBER}"
                }
            }
        }
    }
}
