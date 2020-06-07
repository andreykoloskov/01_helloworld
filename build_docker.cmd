if exist packages (
    rd /s /q packages
)
md packages

::windows
call build_windows.cmd
copy build\*.msi packages\
.\build\bin\Release\helloworld_cli.exe

::ubuntu
docker build -f ./DockerfileUbuntu -t andreykoloskov/helloworld:v1 .
docker run --rm --name helloworld -d andreykoloskov/helloworld:v1 /bin/sh -c "while true; do sleep 1; done"
docker cp helloworld:/app/build_linux/deb/ packages/
docker stop helloworld
copy packages\deb\*.deb packages\
rd /s /q packages\deb
docker run --rm --name helloworld andreykoloskov/helloworld:v1
docker build -f ./DockerfileUbuntuTest -t andreykoloskov/helloworld:v2 .
docker run --rm --name helloworld andreykoloskov/helloworld:v2

::centos
docker build -f ./DockerfileCentos -t andreykoloskov/helloworld:v3 .
docker run --rm --name helloworld -d andreykoloskov/helloworld:v3 /bin/sh -c "while true; do sleep 1; done"
docker cp helloworld:/app/build_linux/rpm/ packages/
docker stop helloworld
copy packages\rpm\*.rpm packages\
rd /s /q packages\rpm
docker run --rm --name helloworld andreykoloskov/helloworld:v3
docker build -f ./DockerfileCentosTest -t andreykoloskov/helloworld:v4 .
docker run --rm --name helloworld andreykoloskov/helloworld:v4

:: docker run -it helloworld /bin/bash
:: docker rm $(docker ps -a -q)
:: docker rmi -f $(docker images -a -q)
:: docker rmi -f 1233

:: docker images -a

:: https://dker.ru/docs/

:: docker run ubuntu /bin/echo 'Hello world'
:: docker run -t -i ubuntu /bin/bash
:: docker run -d ubuntu /bin/sh -c "while true; do echo hello world; sleep 1; done"
:: docker ps
:: docker logs insane_babbage
:: docker stop insane_babbage

:: docker run -d -P --name web training/webapp python app.py
:: docker run -d -p 80:5000 training/webapp python app.py
:: docker ps -l
:: docker inspect web
:: docker port nostalgic_morse 5000
:: docker logs -f nostalgic_morse
:: docker top nostalgic_morse
:: docker inspect nostalgic_morse

:: docker search centos
:: docker commit -m "Added json gem" -a "Kate Smith" 0b2616b0e5a8 ouruser/sinatra:v2
:: docker push andreykoloskov/helloworld
:: docker pull andreykoloskov/helloworld

:: docker network ls