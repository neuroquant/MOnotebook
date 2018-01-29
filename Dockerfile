FROM jupyter/scipy-notebook

USER root

# Install octave and gnuplot
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                  octave \
                  octave-control octave-image octave-io octave-optim octave-signal octave-statistics \
                  octave-nan liboctave-dev \
                  gnuplot && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER

RUN pip install octave_kernel  && \
    rm -rf .cache/pip

USER root

#RUN python -m octave_kernel.install
RUN conda install -c conda-forge oct2py

# # Copy repo into ${HOME}, make user own $HOME
# COPY . ${HOME}
# RUN chown -R ${NB_USER} ${HOME}
# USER ${NB_USER}
