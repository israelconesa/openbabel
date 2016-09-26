FROM alpine:latest

# Set proxy (remove if not needed)
ENV http_proxy http://10.9.1.80:8080
ENV https_proxy http://10.9.1.80:8080

# Install dependencies
RUN apk update && apk add cmake make gcc g++

# Download source
ADD https://sourceforge.net/projects/openbabel/files/latest/download/openbabel-openbabel-2-4-0.tar.gz /

# Extract source files
RUN tar -xvzf /openbabel-openbabel-2-4-0.tar.gz && rm /openbabel-openbabel-2-4-0.tar.gz

# create build folder
RUN mkdir /obabel-build

# Compile openbabel
RUN cd /obabel-build && cmake /openbabel-openbabel-2-4-0
RUN cd /obabel-build && make -j4 && make install -j4

# Removing unnecesary packages
RUN apk del gcc g++

# Remove source files
RUN rm -r /openbabel-openbabel-2-4-0

ENTRYPOINT ["sh"]
