#!/bin/bash
elastalert-create-index --no-ssl --no-verify-certs --config /opt/elastalert/config/config.yaml
elastalert --config /opt/elastalert/config/config.yaml
