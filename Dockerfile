FROM phusion/baseimage:latest

# When proxy required
ENV http_proxy http://10.9.1.80:8080
ENV https_proxy http://10.9.1.80:8080

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get update

RUN apt-get install -y openbabel

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
