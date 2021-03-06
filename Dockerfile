FROM jupyter/scipy-notebook

USER root

# The following keeps failing docker builds
# 
# # Install latest stable octave version
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#                   software-properties-common \
#                   python-software-properties && \
#     add-apt-repository ppa:octave/stable && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \
#                   libgraphicsmagick++1-dev \
#                   libhdf5-serial-dev \
#                   octave=4.2.2 liboctave-dev \
#                   octave-general octave-struct octave-control octave-image octave-signal \
#                   octave-statistics octave-communications octave-parallel \
#                   gnuplot-x11 && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

RUN apt-get update; \
    apt-get install -y nodejs; \
    apt-get install -y npm; \
    apt-get install -y autoconf;\
    apt-get install -y software-properties-common 

RUN sudo apt-add-repository ppa:octave/stable;\
    apt-get update

RUN apt-get update && apt-get -y install ghostscript && apt-get clean

RUN apt-get install -y bzip2 libpng-dev libjpeg-dev libjasper-dev libbz2-dev libfreetype6 libgomp1 libtiff-dev

# Fetch and extract Graphsmagick 
RUN cd $HOME; \
    wget ftp://ftp.icm.edu.pl/pub/unix/graphics/GraphicsMagick/1.3/GraphicsMagick-1.3.25.tar.gz; \
    tar -xvzf GraphicsMagick-1.3.25.tar.gz

# Build Graphsmagick with 16-bit levels
RUN cd $HOME/GraphicsMagick-1.3.25; \
    ./configure  --with-quantum-depth=16 --enable-shared --disable-static --with-magick-plus-plus=yes --with-png=yes --with-tiff=yes --with-jpeg=yes --with-jp2=yes --with-dot=yes --with-jbig=yes; \
    make -j4; \
    make install; \
    cd /usr/local/include; \
    find GraphicsMagick/ -type d | xargs sudo chmod 755



# After building GM, octave must be built manually. Below are the dependencies for Octave
RUN apt-get install -y gcc g++ gfortran libblas-dev liblapack-dev libpcre3-dev libarpack2-dev libcurl4-gnutls-dev epstool libfftw3-dev transfig libfltk1.3-dev libfontconfig1-dev libfreetype6-dev libgl2ps-dev libglpk-dev libreadline-dev gnuplot libhdf5-serial-dev libsndfile1-dev llvm-dev lpr texinfo libgl1-mesa-dev libosmesa6-dev pstoedit portaudio19-dev libqhull-dev libqrupdate-dev libqscintilla2-dev libqt4-dev libqtcore4 libqtwebkit4 libqt4-network libqtgui4 libqt4-opengl-dev libsuitesparse-dev texlive libxft-dev zlib1g-dev automake bison flex gperf gzip icoutils librsvg2-bin libtool perl rsync tar openjdk-8-jdk

# Build octave 
RUN cd $HOME; \
    wget https://ftp.gnu.org/gnu/octave/octave-4.2.1.tar.gz; \
    tar -xvzf octave-4.2.1.tar.gz; \
    cd octave-4.2.1; \
    ./configure LD_LIBRARY_PATH=/opt/OpenBLAS/lib CPPFLAGS=-I/opt/OpenBLAS/include LDFLAGS=-L/opt/OpenBLAS/lib; \
    make -j4; \
    make install

# Liboctave install -- START
RUN cd $HOME; \
wget http://ftp.us.debian.org/debian/pool/main/o/octave/liboctave2_3.8.2-4_amd64.deb;\
wget http://ftp.us.debian.org/debian/pool/main/a/atlas/libatlas3-base_3.10.2-7_amd64.deb;\
#wget http://ftp.us.debian.org/debian/pool/main/b/blas/libblas3_1.2.20110419-10_amd64.deb;\
#wget http://ftp.us.debian.org/debian/pool/main/o/openblas/libopenblas-base_0.2.12-1_amd64.deb;\
#wget http://ftp.us.debian.org/debian/pool/main/a/arpack/libarpack2_3.1.5-3_amd64.deb;\
#wget http://ftp.us.debian.org/debian/pool/main/g/glibc/multiarch-support_2.19-18+deb8u10_amd64.deb;\
wget http://ftp.us.debian.org/debian/pool/main/s/suitesparse/libamd2.3.1_4.2.1-3_amd64.deb;\
wget http://ftp.us.debian.org/debian/pool/main/s/suitesparse/libcamd2.3.1_4.2.1-3_amd64.deb;\
wget http://ftp.us.debian.org/debian/pool/main/s/suitesparse/libccolamd2.8.0_4.2.1-3_amd64.deb;\
wget http://ftp.us.debian.org/debian/pool/main/s/suitesparse/libcholmod2.1.2_4.2.1-3_amd64.deb;\
wget http://ftp.us.debian.org/debian/pool/main/s/suitesparse/libcolamd2.8.0_4.2.1-3_amd64.deb;\
wget http://ftp.us.debian.org/debian/pool/main/s/suitesparse/libcxsparse3.1.2_4.2.1-3_amd64.deb;\
wget http://ftp.us.debian.org/debian/pool/main/h/hdf5/libhdf5-8_1.8.13+docs-15+deb8u1_amd64.deb;\
wget http://ftp.us.debian.org/debian/pool/main/s/suitesparse/libumfpack5.6.2_4.2.1-3_amd64.deb;\
dpkg -i $HOME/libamd2.3.1_4.2.1-3_amd64.deb;\
dpkg -i $HOME/libcamd2.3.1_4.2.1-3_amd64.deb;\
dpkg -i $HOME/libcolamd2.8.0_4.2.1-3_amd64.deb;\
dpkg -i $HOME/libccolamd2.8.0_4.2.1-3_amd64.deb;\
dpkg -i $HOME/libcholmod2.1.2_4.2.1-3_amd64.deb;\
dpkg -i $HOME/libumfpack5.6.2_4.2.1-3_amd64.deb;\
dpkg -i $HOME/libhdf5-8_1.8.13+docs-15+deb8u1_amd64.deb;\
dpkg -i $HOME/libcxsparse3.1.2_4.2.1-3_amd64.deb;\
#dpkg -i $HOME/multiarch-support_2.19-18+deb8u10_amd64.deb;\
#dpkg -i $HOME/libarpack2_3.1.5-3_amd64.deb;\
#dpkg -i $HOME/libopenblas-base_0.2.12-1_amd64.deb;\
#dpkg -i $HOME/libblas3_1.2.20110419-10_amd64.deb;\
dpkg -i $HOME/libatlas3-base_3.10.2-7_amd64.deb;\
dpkg -i $HOME/liboctave2_3.8.2-4_amd64.deb


# Liboctave install -- END

# Following is working no longer
#RUN apt-get install -y liboctave2


# Octave add some packages 

RUN mkdir /home/packages
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/control-3.0.0.tar.gz -P /home/packages
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/general-2.0.0.tar.gz -P /home/packages
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/signal-1.3.2.tar.gz -P /home/packages
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/image-2.6.1.tar.gz -P /home/packages
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/io-2.4.7.tar.gz -P /home/packages
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/statistics-1.3.0.tar.gz -P /home/packages
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/struct-1.0.14.tar.gz -P /home/packages
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/optim-1.5.2.tar.gz -P /home/packages
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/dicom-0.2.0.tar.gz -P /home/packages

# Install Octave forge packages
RUN octave --eval "cd /home/packages; \
                   more off; \
                   pkg install \
                   general-2.0.0.tar.gz \
                   io-2.4.7.tar.gz \
                   control-3.0.0.tar.gz \
                   signal-1.3.2.tar.gz \
                   image-2.6.1.tar.gz \
                   struct-1.0.14.tar.gz\
                   optim-1.5.2.tar.gz\
                   statistics-1.3.0.tar.gz"


USER $NB_USER

RUN pip install octave_kernel  && \
    rm -rf .cache/pip

USER root

#RUN python -m octave_kernel.install
RUN conda install -c conda-forge oct2py

USER $NB_USER
