FROM centos:8

RUN yum update -y && yum install -y vim python3 python3-pip

WORKDIR /app

COPY ./requirements.txt .
COPY /app/ .

COPY /app/send.py /usr/local/bin
COPY /app/fetch.py /usr/local/bin

RUN chmod 755 /usr/local/bin/send.py /usr/local/bin/fetch.py

RUN pip3 install -r requirements.txt

