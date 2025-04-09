pipeline {
	environment {
		IMAGE_NAME = "alpinehelloworld2"
		IMAGE_TAG = "latest"
		STAGING = "alpinehelloworld2-staging"
		PRODUCTION = "alpinehelloworld2-production"
	}
	agent none
	stages{
		stage('Build image') {
			agent any
			steps {
				script {
					sh 'docker build -t sstfort/$IMAGE_NAME:$IMAGE_TAG .'
				}
			}
		}
		stage('Run container based on built image') {
			agent any
			steps {
				script {
					sh '''
     						docker stop $IMAGE_NAME || true
                    				docker rm $IMAGE_NAME || true
						docker run --name $IMAGE_NAME -d -p 40:6500 -e PORT=6500 sstfort/$IMAGE_NAME:$IMAGE_TAG
						sleep 5
					'''
				}
			}
		}
		stage('Test image') {
			agent any
			steps {
				script {
					sh 'curl http://172.17.0.1 | grep -q "Please use the"'
				}
			}
		}
		stage('Clean container') {
			agent any
			steps {
				script {
					sh '''
						docker stop $IMAGE_NAME || true
                    				docker rm $IMAGE_NAME || true
					'''
				}
			}
		}
		stage('Push image in staging and deploy') {
			when{
				expression { GIT_BRANCH == 'origin/master'}
			}
			agent any
			environment {
				HEROKU_API_KEY = credentials('heroku_api_key')
			}
			steps {
				script {
					sh '''
						echo "Deploying to STAGING"
						heroku container:login

						# Create the app if not exists
						heroku apps:info -a $STAGING || heroku create $STAGING

						# Set the stack to container for Docker deployment
						heroku stack:set container -a $STAGING

						# Push and release
						heroku container:push -a $STAGING web
						heroku container:release -a $STAGING web
					'''
				}
			}
		}
		stage('Push image in production and deploy') {
			when{
				expression { GIT_BRANCH == 'origin/master'}
			}
			agent any
			environment {
				HEROKU_API_KEY = credentials('heroku_api_key')
			}
			steps {
				script {
					sh '''
						echo "Deploying to PRODUCTION"
						heroku container:login

						# Create the app if not exists
						heroku apps:info -a $PRODUCTION || heroku create $PRODUCTION

						# Set the stack to container for Docker deployment
						heroku stack:set container -a $PRODUCTION

						# Push and release
						heroku container:push -a $PRODUCTION web
						heroku container:release -a $PRODUCTION web
					'''
				}
			}
		}
	}
}
