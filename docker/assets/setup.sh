#!/bin/sh

echo "Setting up aliases"
echo "IncludeOptional /opt/bitnami/apache/conf/aliases/*.conf"  >> /opt/bitnami/apache/conf/httpd.conf
