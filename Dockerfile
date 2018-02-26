FROM alpine:latest

ENV user_dir /home/obuilder
ENV build_path ${user_dir}/obuild
ENV install_path ${user_dir}/obinstall

# Create obuilder user and add it to sudoers without password
RUN adduser -D obuilder \
        && echo "obuilder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install dependencies
RUN apk update && apk add  \
        cmake \
        cairo-dev \
        zlib-dev \
        libxml2-dev \
        python-dev \
        gcc \
        make \
        g++

# Create build and installation folders
RUN mkdir ${build_path} && mkdir ${install_path}

# Download openbabel source
ADD https://github.com/openbabel/openbabel/archive/openbabel-2-4-1.tar.gz ${user_dir}

# Download eigen source
ADD http://bitbucket.org/eigen/eigen/get/3.3.3.tar.gz ${user_dir}

# Extract openbabel and eigen source files
RUN mkdir -p ${user_dir}/openbabel-2.4.1 && tar xvzf ${user_dir}/openbabel-2-4-1.tar.gz -C ${user_dir}/openbabel-2.4.1 --strip-components=1 \
              && mkdir -p ${user_dir}/eigen3 && tar xvzf ${user_dir}/3.3.3.tar.gz -C ${user_dir}/eigen3 --strip-components=1

# Give user_dir ownership of the folder
RUN chown obuilder:obuilder ${user_dir}/*

# Compile openbabel
RUN su obuilder -c "cd ${build_path} && cmake ${user_dir}/openbabel-2.4.1 \
                  -DCMAKE_INSTALL_PREFIX=${install_path} \
                  -DEIGEN3_INCLUDE_DIR=${user_dir}/eigen3 \
                  -DPYTHON_BINDINGS=ON \
                  -DBUILD_GUI=OFF"

RUN su obuilder -c "cd ${build_path} && make -j4 && make install -j4"

# Removing unnecesary packages (must be checked)
# RUN apk del gcc g++

# Remove source and build files (must be checked)
# RUN rm -r openbabel-2.4.1 && rm -r /obuild

# Set path to openbabel final bin location
ENV PATH $PATH:${install_path}/bin

# Switch user and set entrypoint to its home folder
USER obuilder
ENTRYPOINT ["sh"]
WORKDIR ${install_path}
