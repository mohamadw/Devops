pipeline
{
agent {label 'slave'};
stages{
	stage('Clone and build project'){
		steps{
		sh "git clone https://github.com/spring-projects/spring-petclinic"

		sh cd spring-petclinic
		}

		script{
			"./mvnw package"
		}
}
	}
}
}
