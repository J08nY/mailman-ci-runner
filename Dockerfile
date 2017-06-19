FROM ubuntu:16.04

# Install the depdencies in the repo.
# Install tox.
# create a new user to run tests.
RUN apt-get -y update \
    && apt-get -y install python-pip python3-pip \
       git openssh-server postgresql-client libpq-dev python3-dev \
       libsqlite3-dev libmysqlclient-dev libreadline-dev python-dev \
    && pip3 install tox \
    && useradd runner --create-home

# Download and compile the Python3.4 version.
WORKDIR /tmp/
RUN wget https://www.python.org/ftp/python/3.4.6/Python-3.4.6.tgz \
    && tar xzf Python-3.4.6.tgz \
    && rm Python-3.4.6.tgz \
    && cd /tmp/Python-3.4.6 \
    && ./configure \
    && make \
    && make install

# Download and compile Python 3.6
WORKDIR /tmp/
RUN wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz \
    && tar xzf Python-3.6.1.tgz \
    && cd /tmp/Python-3.6.1 \
    && ./configure \
    && make \
    && make install

# Add the configuration files to the container.
COPY mysql.cfg postgres.cfg /home/runner/configs/

# Change the permissions for configs directory.
RUN chown -R runner:runner /home/runner/configs

# Switch to runner user and set the workdir
USER runner
WORKDIR /home/runner
