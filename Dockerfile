FROM ubuntu:16.04
MAINTAINER Speden Aave <renfld@gmail.com>
WORKDIR /tmp
RUN apt-get update 
RUN apt-get install -y unzip curl build-essential git libpng-dev libxxf86vm1 libxxf86vm-dev libxi-dev libxrandr-dev graphviz mercurial cmake libpng-dev libjpeg-dev libtiff-dev libglu1-mesa-dev libboost-iostreams-dev libboost-program-options-dev libboost-system-dev libboost-serialization-dev libopencv-dev libcgal-dev libcgal-qt5-dev libatlas-base-dev libsuitesparse-dev
RUN mkdir /tmp/build
RUN git clone -b develop --recursive https://github.com/openMVG/openMVG.git /tmp/build/openmvg && \
    mkdir /tmp/build/openmvg_build && cd /tmp/build/openmvg_build && \
    cmake -DCMAKE_BUILD_TYPE=RELEASE . /tmp/build/openmvg/src -DCMAKE_INSTALL_PREFIX=/opt/openmvg && \
    make -j2 && make install
RUN main_path=/tmp/build && \
    hg clone https://bitbucket.org/eigen/eigen#3.2 /tmp/build/eigen && \
    mkdir /tmp/build/eigen_build && cd /tmp/build/eigen_build && \
    cmake . ../eigen && \
    make -j2 && make install
RUN git clone https://github.com/cdcseacave/VCG.git /tmp/build/vcglib && \
    git clone https://ceres-solver.googlesource.com/ceres-solver /tmp/build/ceres_solver && \
    mkdir /tmp/build/ceres_build && cd /tmp/build/ceres_build && \
    cmake . ../ceres_solver/ -DMINIGLOG=ON -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF && \
    make -j2 && make install
RUN git clone https://github.com/cdcseacave/openMVS.git /tmp/build/openmvs && \
    mkdir /tmp/build/openmvs_build && cd /tmp/build/openmvs_build && \
    cmake . ../openmvs -DCMAKE_BUILD_TYPE=Release -DVCG_DIR="/tmp/build/vcglib" -DCMAKE_INSTALL_PREFIX=/opt/openmvs && \
    make -j2 && make install
RUN rm -rf /tmp/build

RUN echo "iPhone X;4.89" >> /opt/openmvg/share/openMVG/sensor_width_camera_database.txt


COPY MvgMvs_Pipeline.py .
WORKDIR /datasets
#ENTRYPOINT ["/usr/bin/python", "MvgMvs_Pipeline.py"]
ENTRYPOINT ["tail", "-f", "/dev/null"]
#ENTRYPOINT ["/usr/bin/python", "-u", "/opt/pipeline/pipeline.py"]
