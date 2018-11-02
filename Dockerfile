FROM ubuntu:16.04
LABEL description = "Lightweight image with Conda, Jupyter Notebook and Snakemake"

# Install Miniconda3 and prerequisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends bzip2 curl ca-certificates
RUN curl https://repo.continuum.io/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O && \
    bash Miniconda3-4.5.11-Linux-x86_64.sh -bf -p /opt/miniconda3/ && \
    rm Miniconda3-4.5.11-Linux-x86_64.sh

# Add Conda to PATH
ENV PATH="/opt/miniconda3/bin:${PATH}"

# Use bash as shell
SHELL ["/bin/bash", "-c"]

# Set up the Conda environment
COPY environment.yml .
RUN conda env update -n root -f environment.yml && \
    conda clean --all

# Install Jupyter Notebook and set default user to UID 1000
RUN pip install --no-cache-dir notebook==5.*
ENV NB_USER nbuser
ENV NB_UID 1000

RUN adduser --disabled-password --no-create-home \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Define workdir and set ownership to NB_USER
WORKDIR /home
ENV HOME /home
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

# Add the workflow files and the code
COPY Snakefile config.yml ./
COPY code ./code/
COPY notebooks ./notebooks/

# Start Bash shell by default
CMD /bin/bash
