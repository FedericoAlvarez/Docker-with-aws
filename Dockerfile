FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
		ca-certificates \
		curl \
		rsync \
		openssl \
		python2.7

#Install Docker
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.12.3
ENV DOCKER_SHA256 626601deb41d9706ac98da23f673af6c0d4631c4d194a677a9a1a07d7219fa0f

RUN set -x \
	&& curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
	&& echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
	&& tar -xzvf docker.tgz \
	&& mv docker/* /usr/local/bin/ \
	&& rmdir docker \
	&& rm docker.tgz \
	&& docker -v

COPY docker-entrypoint.sh /usr/local/bin/

#Install AWS Client
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python2.7 get-pip.py
RUN pip install awscli

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash"]
