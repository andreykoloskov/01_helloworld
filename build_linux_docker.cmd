docker build -t helloworld:v1 .

docker run helloworld:v1

rem docker rm $(docker ps -a -q)
rem docker rmi $(docker images -a -q)