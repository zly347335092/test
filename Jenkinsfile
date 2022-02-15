pipeline {
    agent {
        kubernetes {
            label 'jenkins-pod'
            defaultContainer 'jnlp'
            yaml """
            apiVersion: v1
            kind: Pod
            metadata:
              labels:
                app: jenkins-slave-pod
            spec:
              containers:
              - name: golang
                image: golang:1.12
                command:
                - cat
                tty: true
              - name: kaniko
                image: registry.cn-beijing.aliyuncs.com/acs-sample/jenkins-slave-kaniko:0.6.0
                command:
                - cat
                tty: true
                volumeMounts:
                - name: ymian
                  mountPath: /root/.docker
              - name: kubectl
                image: roffe/kubectl:v1.13.2
                command:
                - cat
                tty: true
              - name: busybox
                image: ymian/busybox
                command:
                - cat
                tty: true
              volumes:
              - name: ymian
                secret:
                  secretName: jenkins-docker-cfg
                  items:
                  - key: config.json
                    path: config.json
            """
        }
    }

    stages {
        stage('Build') {
            steps {
                sh label:'maven building', script: ''
            }
        }

        stage('Image Build And Publish') {
            steps {
                container("kaniko") {
                    sh "kaniko -f `pwd`/Dockerfile -c `pwd` -d registry.cn-chengdu.aliyuncs.com/zlydock/demo"
                }
            }
        }

        stage('Deploy to pro') {
            steps {
                container("kubectl") {
                    withKubeConfig(
                        [
                            credentialsId: 'pro-env',
                            serverUrl: 'https://kubernetes.default.svc.cluster.local'
                        ]
                    ) {
                        sh '''
                        kubectl apply -f `pwd`/deploy.yaml -n ci
                        kubectl wait --for=condition=Ready pod -l app=cicd-demo --timeout=60s -n ci
                        '''
                    }
                }
            }
        }
    }
}
