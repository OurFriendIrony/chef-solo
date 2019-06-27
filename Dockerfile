FROM library/ubuntu:18.04

########################################################
# Prep Environment

RUN apt update -y
RUN apt install -y \
      sudo netcat telnet bc net-tools lsof nmap dnsutils iproute2 \
      tar git vim tree curl wget gnupg2

########################################################
# UX
RUN echo "alias ll='ls -al'" >> /root/.bashrc \
      && echo "export PS1='\$(whoami): \$(pwd) > '" >> /root/.bashrc \
      && echo 'export PATH="/opt/chefdk/embedded/bin:$PATH"'

RUN git config --global user.email "no@one" \
      && git config --global user.name "no@one"

########################################################
# Install ChefDK

RUN curl -s https://omnitruck.chef.io/install.sh \
      |  bash -s -- -P chefdk

########################################################
# Prep Project

WORKDIR /var
RUN chef generate repo chef --chef-license=accept
WORKDIR /var/chef

RUN echo '{ "run_list":[ "recipe[example]" ] }' > run.json \
      && touch run.log

#RUN chef-solo -j /var/chef/run.json

########################################################

COPY resources/entry/* /
ENTRYPOINT [ "/entrypoint.sh" ]

