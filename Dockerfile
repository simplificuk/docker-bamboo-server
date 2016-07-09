FROM anapsix/alpine-java:jdk

# Configuration variables
ENV BAMBOO_HOME     /var/atlassian/bamboo
ENV BAMBOO_INSTALL  /opt/atlassian/bamboo
ENV BAMBOO_VERSION  5.12.2.1

# Install Atlassian Bamboo and helper tools

RUN	apk --update add curl tar git perl ruby docker \
	&& mkdir -p ${BAMBOO_HOME} \
	&& mkdir -p ${BAMBOO_INSTALL} \
	&& curl -Ls "https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${BAMBOO_VERSION}.tar.gz" | tar -xz --directory "${BAMBOO_INSTALL}" --strip-components=1 --no-same-owner \
	&& curl -Ls "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.36.tar.gz" | tar -xz --directory "${BAMBOO_INSTALL}/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.36/mysql-connector-java-5.1.36-bin.jar" \
	&& chown -R daemon:daemon ${BAMBOO_INSTALL} \
	&& mkdir /sbin/.ssh \
	&& chmod 777 /sbin/.ssh

EXPOSE 8085
EXPOSE 54663

USER daemon:daemon

VOLUME ${BAMBOO_HOME}

WORKDIR ${BAMBOO_HOME}

CMD ["sh", "-c", "${BAMBOO_INSTALL}/bin/start-bamboo.sh -fg"]
