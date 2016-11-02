FROM centos:7
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

RUN yum -y install @"Development Tools" rpm-build rpmdevtools patch curl less vim-enhanced \
 && rpmdev-setuptree

WORKDIR /root/rpmbuild
ADD SPECS/ ./SPECS/
ADD SOURCES/ ./SOURCES/

RUN source_urls=`rpmspec -P ./SPECS/lua53.spec | awk '/^Source[0-9]*:\s*http/ {print $2}'` \
 && for source_url in $source_urls; do \
      source_file=${source_url##*/}; \
      (cd ./SOURCES && if [ ! -f ${source_file} ]; then curl -sLO ${source_url}; fi); \
    done

#RUN yum install -y epel-release \
# && yum-builddep -y ./SPECS/lua53.spec \
# && rpmbuild -bb ./SPECS/lua53.spec \
# && yum install -y ./RPMS/x86_64/*.rpm
