FROM pytorch/pytorch:1.5-cuda10.1-cudnn7-devel

RUN apt-get update && apt-get upgrade -y && apt-get install -y git vim htop wget curl \
	build-essential checkinstall cmake pkg-config yasm gfortran

RUN pip install transforms3d &&\
    wget -r -l1 -np -nd -nc http://cdaweb.gsfc.nasa.gov/pub/software/cdf/dist/latest-release/linux/ -A cdf*-dist-all.tar.gz &&\
    tar xf cdf*-dist-all.tar.gz -C ./ && \
    cd cdf*dist &&\
    apt install -y build-essential gfortran libncurses5-dev && \
    make OS=linux ENV=gnu CURSES=yes FORTRAN=no UCOPTIONS=-O2 SHARED=yes -j4 all &&\
    make install #no sudo
RUN pip install git+https://github.com/spacepy/spacepy.git
RUN echo 'export CDF_BASE=/cdf37_0-dist' >> ~/.bashrc &&\
    echo 'export CDF_INC=$CDF_BASE/include' >> ~/.bashrc &&\
    echo 'export CDF_LIB=$CDF_BASE/lib' >> ~/.bashrc &&\
    echo 'export CDF_BIN=$CDF_BASE/bin' >> ~/.bashrc &&\
    echo 'export LD_LIBRARY_PATH=$CDF_BASE/lib:$LD_LIBRARY_PATH' >> ~/.bashrc

ENV CDF_BASE /cdf37_0-dist
ENV CDF_INC /cdf37_0-dist/include
ENV CDF_LIB /cdf37_0-dist/lib
ENV CDF_BIN /cdf37_0-dist/bin

RUN pip install numpy && pip install pyyaml
RUN git clone https://github.com/jutanke/DMGNN.git && cd DMGNN/torchlight && python setup.py install

RUN pip install numba
RUN echo "0" && pip install git+https://github.com/jutanke/mocap.git
