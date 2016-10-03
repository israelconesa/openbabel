FROM alpine:latest

# Set proxy (remove if not needed)
ENV http_proxy http://10.9.1.80:8080
ENV https_proxy http://10.9.1.80:8080

# Install dependencies
RUN apk update && apk add  \
        cmake \
         make \
         gcc \
        g++ \
        cairo

# Download source
ADD https://sourceforge.net/projects/openbabel/files/latest/download/openbabel-openbabel-2-4-0.tar.gz /

# create build folder
RUN mkdir /obabel-build

# Add user and granting permissions to installation folder
RUN adduser -D obuser \
        && echo "obuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
        && mkdir /home/obuser/openbabel-2-4-0 \
        && chown obuser:obuser /home/obuser/openbabel-2-4-0

# Extract source files
RUN tar -xvzf /openbabel-openbabel-2-4-0.tar.gz && rm /openbabel-openbabel-2-4-0.tar.gz

# Compile openbabel
RUN cd /obabel-build && cmake /openbabel-openbabel-2-4-0 -DCMAKE_INSTALL_PREFIX=/home/obuser/openbabel-2-4-0
RUN cd /obabel-build && make -j4 && make install -j4

# Removing unnecesary packages
RUN apk del gcc g++

# Remove source and build files
RUN rm -r /openbabel-openbabel-2-4-0 && rm -r /obabel-build

# Set path to openbabel final bin location
ENV PATH $PATH:/home/obuser/openbabel-2-4-0/bin

# Switch user and set entrypoint to its home folder
USER obuser
ENTRYPOINT ["sh"]
WORKDIR /home/obuser/openbabel-2-4-0
