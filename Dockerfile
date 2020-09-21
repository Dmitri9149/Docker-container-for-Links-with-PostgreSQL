FROM ocaml/opam2:ubuntu-18.04
RUN mkdir links_examples
WORKDIR links_examples
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

COPY web_examples . 
RUN chmod 755 web_examples 

CMD bash

