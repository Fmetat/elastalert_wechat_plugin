FROM python:2.7.15-alpine3.9

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

RUN apk add --update --no-cache curl gcc tar tzdata python2 make libmagic libffi-dev libffi openssl-dev musl-dev linux-headers && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    mkdir -p ${ELASTALERT_PLUGIN_DIRECTORY} && \
    mkdir -p ${ELASTALERT_CONFIG} && \
    mkdir -p ${RULES_DIRECTORY} && \
    curl -Lo elastalert.tar.gz ${ELASTALERT_URL} && \
    tar -zxvf elastalert.tar.gz -C ${ELASTALERT_HOME} --strip-components 1 && \
    rm -rf elastalert.tar.gz
	
RUN python setup.py install

COPY ./run.sh ./            
      
COPY ./elastalert_modules/* ${ELASTALERT_PLUGIN_DIRECTORY}/

# Launch Elastalert when a container is started.
CMD ["/bin/bash","run.sh"]
