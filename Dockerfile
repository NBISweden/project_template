FROM ubuntu:16.04
LABEL description = "Lightweight image with Conda and Snakemake"

# Install Miniconda3 and prerequisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends bzip2 curl ca-certificates
RUN curl https://repo.continuum.io/miniconda/Miniconda3-4.3.31-Linux-x86_64.sh -O && \
    bash Miniconda3-4.3.31-Linux-x86_64.sh -bf -p /opt/miniconda3/ && \
    rm Miniconda3-4.3.31-Linux-x86_64.sh

# Add Conda to PATH
ENV PATH="/opt/miniconda3/bin:${PATH}"

# Use bash as shell
SHELL ["/bin/bash", "-c"]

# Set workdir
WORKDIR /home

# Set up the Conda environment
COPY environment.yml .
RUN conda env update -n root -f environment.yml && \
    conda clean --all

# Add the workflow files
COPY Snakefile config.yml ./

# Start Bash shell by default
CMD /bin/bash
