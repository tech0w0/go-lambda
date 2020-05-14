pipeline {
    agent any

    tools {
     go { 'go-1.14' }
    }

    environment {
    XDG_CACHE_HOME = '/tmp/.cache'
    CGO_ENABLED='0'
    }

    stages {
       stage('Checkout'){
           steps{
              checkout scm
           }
       }

       stage('hello AWS') {
           steps {
               withAWS(credentials: 'aws-credentials', region: 'eu-central-1') {
                   sh 'echo "hello KB">hello.txt'
                   s3Upload acl: 'Private', bucket: 'go-lambda2', file: 'hello.txt'
                   s3Download bucket: 'go-lambda2', file: 'downloadedHello.txt', path: 'hello.txt'
                   sh 'cat downloadedHello.txt'
               }
           }
       }

       stage('Build'){
           steps{
                sh 'go get -u github.com/aws/aws-lambda-go/lambda'
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