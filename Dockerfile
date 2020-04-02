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
    apt-get -y install build-essential python-setuptools python2.7 python2.7-dev libssl-dev git tox python-pip && \
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    rm -rf /var/cache/apk/* && \
    mkdir -p ${ELASTALERT_PLUGIN_DIRECTORY} && \
    mkdir -p ${ELASTALERT_CONFIG} && \
    mkdir -p ${RULES_DIRECTORY} && \
    curl -Lo elastalert.tar.gz ${ELASTALERT_URL} && \
    tar -zxvf elastalert.tar.gz -C ${ELASTALERT_HOME} --strip-components 1 && \
    rm -rf elastalert.tar.gz && \
    pip install -r requirements-dev.txt

RUN echo "#!/bin/sh" >> /opt/elastalert/run.sh && \
    echo "elastalert-create-index --no-ssl --no-verify-certs --config /opt/elastalert/config/config.yaml" >> run.sh && \
    echo "elastalert --config /opt/elastalert/config/config.yaml" >> run.sh && \
    chmod +x /opt/elastalert/run.sh
            
      
COPY ./elastalert_modules/* ${ELASTALERT_PLUGIN_DIRECTORY}/


# Launch Elastalert when a container is started.
CMD ["/bin/sh","run.sh"]
