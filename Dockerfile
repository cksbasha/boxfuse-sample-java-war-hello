FROM  gcr.io/augmented-ward-329505/tomcat
COPY hello-1.0.war /opt/tomcat/webapps
EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh","run"]
