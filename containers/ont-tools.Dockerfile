FROM mambaorg/micromamba:1.5.3

LABEL image.author.name "Kristina K. Gagalova"
LABEL image.author.email "kristina.gagalova@curtin.edu.au"

COPY --chown=$MAMBA_USER:$MAMBA_USER env.yml /tmp/env.yml

RUN micromamba create -n ont-tools

RUN micromamba install -y -n ont-tools -f /tmp/env.yml && \
    micromamba clean --all --yes

ENV PATH /opt/conda/envs/ont-tools/bin:$PATH
