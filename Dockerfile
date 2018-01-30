FROM jupyter/scipy-notebook

USER root

# Get latest stable octave version
RUN apt-get install software-properties-common python-software-properties
RUN add-apt-repository ppa:octave/stable

# Install octave and gnuplot
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                  libgraphicsmagick++1-dev \
                  libhdf5-serial-dev \
                  octave \
                  octave-general octave-struct octave-control octave-image octave-io octave-optim octave-signal \
                  octave-statistics octave-nan octave-communications octave-parallel liboctave-dev \
                  gnuplot-x11 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER

RUN pip install octave_kernel  && \
    rm -rf .cache/pip

USER root

#RUN python -m octave_kernel.install
RUN conda install -c conda-forge oct2py

