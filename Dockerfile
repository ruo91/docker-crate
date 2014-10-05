#
# Dockerfile - Crate
#
# - Build
# git clone https://github.com/ruo91/docker-crate /opt/docker-crate
# docker build --rm -t crate /opt/docker-crate
#
# - Run
# docker run -d  --name="crate" -h "crate" -p 4200:4200 -p 4300:4300 crate
#

# 1. Base images
FROM     ubuntu:14.04
MAINTAINER Yongbok Kim <ruo91@yongbok.net>

# 2. Change the repository
RUN sed -i 's/archive.ubuntu.com/kr.archive.ubuntu.com/g' /etc/apt/sources.list

# 3. The package to update and install
RUN apt-get update && apt-get install -y curl

# 4. Set the environment variable
WORKDIR /opt
ENV SRC_DIR /opt

# 5. Set the Oracle JDK
#ENV JDK_URL http://download.oracle.com/otn-pub/java/jdk
ENV JDK_URL http://cdn.yongbok.net/ruo91/jdk
ENV JDK_VER_1 8u20-b26
ENV JDK_VER_2 8u20
ENV JAVA_HOME /usr/local/jdk
ENV PATH $PATH:$JAVA_HOME/bin
RUN curl -L -o jdk.tar.gz "$JDK_URL/$JDK_VER_1/jdk-$JDK_VER_2-linux-x64.tar.gz" -H 'Cookie: oraclelicense=accept-securebackup-cookie' \
 && tar xzf jdk.tar.gz && mv jdk1* /usr/local/jdk && rm -f jdk.tar.gz

# 6. Set the environment variable for Oracle JDK
RUN echo '# JDK' >> /etc/profile \
 && echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile \
 && echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile \
 && echo '' >> /etc/profile \

# 7. Crate
ENV CRATE_URL https://cdn.crate.io/downloads/releases
ENV CRATE_VER 0.44.4
ENV CRATE_HOME $SRC_DIR/crate
ENV PATH $PATH:CRATE_HOME/bin
RUN curl -L -o crate.tar.gz "$CRATE_URL/crate-$CRATE_VER.tar.gz" \
 && tar xzf crate.tar.gz && rm -f crate.tar.gz && mv crate* crate && chmod a+x $CRATE_HOME/bin/*

# 8. Set the environment variable for Crate
RUN echo '# Crate' >> /etc/profile \
 && echo "export CRATE_HOME=$CRATE_HOME" >> /etc/profile \
 && echo 'export PATH=$PATH:$CRATE_HOME/bin' >> /etc/profile

# 9. Port
EXPOSE 4200 4300

# 10 Start crate
CMD ["/opt/crate/bin/crate"]