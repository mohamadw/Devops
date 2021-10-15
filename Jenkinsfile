pipeline
{

agent {label 'slave'};
environment {
		DOCKERHUB_CREDENTIALS=credentials('mohamadd3-dockerhub')
	}
stages{
	stage('Clone The Project'){
		steps{
            git branch: 'docker5', credentialsId: 'github-private', url: 'https://github.com/mohamadw/Devops.git'                }
	    }
	    
	   stage('SET UP THE ENVIROMENT TO USE DOCKER'){// the ref .... https://stackoverflow.com/questions/60583847/aws-ecr-saying-cannot-perform-an-interactive-login-from-a-non-tty-device-after
		steps{// + make this change sudo chmod 666 /var/run/docker.sock from  https://github.com/palantir/gradle-docker/issues/188
            sh 'sudo usermod -aG docker $USER'

	    } 
	   }

	stage('Build The image') {
      steps {
        sh 'docker build -t mohamadd3/dp-v1:latest .'
      }
    }
    
   
    stage('Login To Dockerhub') {
      steps {
        sh '''echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'''
      }
    }

 stage('PUSH THE IMAGE') {
      steps {
        sh 'docker push mohamadd3/dp-v1:latest'
      }
    }
 
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}