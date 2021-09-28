pipeline
{
agent {label 'slave'};
stages{
	stage('Clone The Project'){
		steps{
		sh "git clone https://github.com/spring-projects/spring-petclinic"
}}

	stage('Build The Project'){
	steps{
			sh "./mvnw package"
	}
	}



}
}

