FROM ubuntu:latest

#Elastalert的release版本号
ENV ELASTALERT_VERSION v0.1.38
ENV ELASTALERT_URL https://github.com/Yelp/elastalert/archive/${ELASTALERT_VERSION}.tar.gz
#Elasticsearch目录设置
ENV ELASTALERT_HOME /opt/elastalert
ENV ELASTALERT_CONFIG /opt/elastalert/config
ENV RULES_DIRECTORY /opt/elastalert/es_rules
ENV ELASTALERT_PLUGIN_DIRECTORY /opt/elastalert/elastalert_modules

#Elasticsearch 工作目录
WORKDIR ${ELASTALERT_HOME}


RUN apt-get update && apt-get upgrade -y && \
    apt-get -y install build-essential python-setuptools python2.7 python2.7-dev libssl-dev git tox python-pip

ADD requirements*.txt ./
RUN pip install -r requirements-dev.txt

RUN echo "#!/bin/sh" >> /opt/elastalert/run.sh && \
    echo "elastalert-create-index --no-ssl --no-verify-certs --config /opt/elastalert/config/config.yaml" >> run.sh && \
    echo "elastalert --config /opt/elastalert/config/config.yaml" >> run.sh && \
    chmod +x /opt/elastalert/run.sh
            
      
COPY ./elastalert_modules/* ${ELASTALERT_PLUGIN_DIRECTORY}/


# Launch Elastalert when a container is started.
CMD ["/bin/sh","run.sh"]
