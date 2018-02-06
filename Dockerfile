#Download base image ubuntu 16.04
FROM ubuntu:16.04
 

# Configure Services and Port
COPY lamp.sh /lamp.sh
RUN ["/lamp.sh"]
 
EXPOSE 80 443
