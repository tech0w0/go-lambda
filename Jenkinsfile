pipeline {
    agent any

    stages {
       stage('Checkout'){
           steps{
              checkout scm
           }
       }

       stage('Test'){
           steps {
              sh 'go get -u github.com/golang/lint/golint'
              sh 'go get -t ./...'
              sh 'golint -set_exit_status'
              sh 'go vet .'
              sh 'go test .'
           }

       }

       stage('Build'){
           steps{
                sh 'GOOS=linux go build -o main main.go'
                sh "zip deployment.zip main"
           }

       }

       stage('Push'){
           steps{
                sh "aws s3 cp deployment.zip s3://go-lambda2"
           }
       }

       stage('Deploy'){
           steps {
               sh "aws lambda update-function-code --function-name Simple \
                                  --s3-bucket go-lambda2 \
                                  --s3-key deployment.zip \
                                  --region eu-central-1"
           }

       }
    }
 }