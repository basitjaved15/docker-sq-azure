FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
USER root
RUN apt-get update && apt-get install -y vim nano net-tools zsh curl sudo systemctl default-jre default-jdk zip wget telnet supervisor elinks apt-utils 
RUN apt-get install -y supervisor nginx


RUN mkdir -p /var/log/supervisor

###################SonrQube Conf#####################

RUN wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.2.1.49989.zip
RUN unzip sonarqube-9.2.1.49989.zip -d /opt/
RUN mv /opt/sonarqube-9.2.1.49989 /opt/sonarqube
RUN rm -rf sonarqube-9.2.1.49989.zip
#RUN mv /opt/sonarqube{-8.7.0.41497,} /opt/sonarqube
RUN useradd -M -d /opt/sonarqube/ -r -s /bin/bash sonarqube
RUN sudo usermod -aG sudo sonarqube
#RUN sudo sysctl -w net.ipv4.route.flush=1
#RUN echo 'vm.max_map_count=262155' >> /etc/sysctl.conf
RUN sudo sh -c "echo 'vm.max_map_count=262144' >> /etc/sysctl.conf"
RUN echo 'ulimit -n 65536' >> /etc/security/limits.conf
#RUN sudo sysctl -p
RUN mkdir -p /scripts
WORKDIR /scripts
RUN chown -R sonarqube:sonarqube /opt/sonarqube/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY sonar.properties /opt/sonarqube/conf/sonar.properties
COPY limits.conf /etc/security/limits.conf
RUN sudo sysctl -p
################NGINX Conf#################
COPY nginx.conf /scripts/nginx.conf
COPY nginx.conf  /etc/nginx/
COPY certs /scripts/certs
COPY certs /etc/pki/tls/sonar
RUN nginx -t
################################


EXPOSE 80:80
EXPOSE 443:443
CMD ["/usr/bin/supervisord"]

