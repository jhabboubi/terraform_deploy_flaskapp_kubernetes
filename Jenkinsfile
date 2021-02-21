pipeline {
		agent any

        }
		stages {
			stage('checkout SCM'){
				steps {
					checkout scm
				}
			}
			stage('terraform init'){
				steps{
					script{
						sh 'terraform init'
                        sh 'terraform refresh'
					}
				}
			}
			stage('Deploy to kubernetes'){
				steps{
					sh 'terraform apply -auto-approve'
				}
			}
		}
	}