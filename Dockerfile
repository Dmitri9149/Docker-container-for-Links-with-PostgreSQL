FROM ocaml/opam2:ubuntu-18.04
RUN mkdir links_folder
WORKDIR links_folder
# basing on the links manual: https://github.com/links-lang/links-tutorial
# that is for Vagrant and Vbox ; here we use that setup for Dockerfile

RUN sudo apt-get update && sudo apt-get install -y libpq-dev \
    &&  echo 'debconf debconf/frontend select Noninteractive' \
    | sudo debconf-set-selections \
    && DEBIAN_FRONTEND=noninteractive sudo apt-get update \
    && sudo apt-get install -yq apt-utils \
    && sudo apt-get install -y  m4 postgresql \
    && opam switch 4.06 \
    && eval `opam config env` \
    && opam update \
    && opam install -y postgresql links links-postgresql \
    && eval `opam config env` && bash

EXPOSE 8080

# vim is installed , it is possible to make links files from 
# within container
RUN sudo apt-get update && sudo apt-get install -y vim

# we can use the ./webexample script to run web examples in container
COPY web_examples ./
USER root
RUN chmod 755 web_examples 


# see https://github.com/links-lang/links/blob/master/INSTALL.md
# using postgres credentials 
# create database with name 'links'; create user 'opam' ;
# (change 'password' to your password in the code and rebuild the image!!!)
# create 'opam' user access to the 'links' database
# create 'test' table;
# create configuration  file  
# the image is for learning purposes ; the db is created on the local machine 
# for running the db lovally
USER postgres
RUN service postgresql restart \
    && psql -c "CREATE DATABASE links;" \
    && psql -c "CREATE USER opam WITH ENCRYPTED PASSWORD 'password';" \
    && psql -c "GRANT ALL ON DATABASE links TO opam;"
USER opam
RUN sudo service postgresql restart \
    && psql -d links -c "CREATE TABLE test (i INTEGER, s TEXT);" \
    && touch config \
    && echo "database_driver=postgresql" >> config \
    && echo "database_args=localhost:5432:opam:password" >> config

CMD sudo service postgresql restart && bash

