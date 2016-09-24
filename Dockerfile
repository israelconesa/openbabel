FROM phusion/baseimage:latest

# When proxy required
# ENV http_proxy http://10.9.1.80:8080
# ENV https_proxy http://10.9.1.80:8080

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get update

# Install applications to compile openbabel
RUN apt-get install -y g++ cmake git

# Clone project from github
RUN cd /usr/local/
RUN git clone https://github.com/openbabel/openbabel.git

# Create build folder
RUN mkdir /usr/local/openbabel-build

# Compile openbabel
RUN cd /usr/local/openbabel-build
RUN cmake ./openbabel
RUN make -j4 && make install

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
