FROM gcc:latest as build
#FROM ubuntu:20.04
COPY . /app

RUN apt-get update \
    && apt-get install -y gcc g++ cmake libboost-test-dev libspdlog-dev \
    && echo "CREATE linux directory" \
    && rm -rf /app/build_linux \
    && mkdir /app/build_linux \
	&& cd /app/build_linux \
	&& export TRAVIS_BUILD_NUMBER=1 \
	&& cmake -D CMAKE_C_FLAGS=-m64 \
			 ../ \
	&& cmake --build . --config Release -- -j12 \
    && ctest . -C Release \
    && cpack -C Release

CMD /app/build_linux/bin/helloworld_cli \
    && echo "\n" \
	&& /app/build_linux/bin/test_version