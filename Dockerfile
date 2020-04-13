FROM ubuntu:bionic
ENV MINETEST_VERSION 5.2.0
RUN apt-get update && apt-get install -y build-essential wget libirrlicht-dev cmake libbz2-dev libpng-dev libjpeg-dev libxxf86vm-dev libgl1-mesa-dev libsqlite3-dev libogg-dev libvorbis-dev libopenal-dev libcurl4-gnutls-dev libfreetype6-dev zlib1g-dev libgmp-dev libjsoncpp-dev luarocks libyaml-dev git libjsoncpp-dev libfuse-dev clang
WORKDIR /tmp
RUN wget https://github.com/minetest/minetest/archive/${MINETEST_VERSION}.tar.gz && tar xf ${MINETEST_VERSION}.tar.gz && mv minetest-${MINETEST_VERSION} ./minetest && rm ${MINETEST_VERSION}.tar.gz
WORKDIR /tmp/minetest
RUN cmake . -DRUN_IN_PLACE=TRUE -DBUILD_SERVER=TRUE -DBUILD_CLIENT=FALSE
RUN make -j $(nproc)
RUN make install

RUN ln -s /usr/include/jsoncpp/json/ /usr/include/json
WORKDIR /tmp
RUN git clone -b master --depth 1 https://github.com/jboero/hashifuse/
WORKDIR hashifuse/K8sFS/
RUN make CC=clang++

RUN luarocks install lyaml

WORKDIR /usr/local
EXPOSE 30000
ENTRYPOINT ["/usr/local/bin/minetestserver"] 
CMD [""]

