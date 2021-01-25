FROM gaow/base-notebook:1.0.0

LABEL maintainer="Diana Cornejo <dmc2245@cumc.columbia.edu>"

USER root

RUN curl -fsSL https://bitbucket.org/statgen/plinkseq/get/5d071291075c.zip -o plinkseq.zip && unzip plinkseq.zip && mv statgen-plinkseq* plinkseq && cd plinkseq && make && rm -f build/execs/*.o && rm -f build/execs/*.dep && mv build/execs/* /usr/local/bin && cd - && rm -rf plinkseq*

# RUN curl -s -o /usr/local/bin/pull-tutorial.sh https://raw.githubusercontent.com/statgenetics/statgen-courses/master/src/pull-tutorial.sh
RUN curl -s -o /usr/local/bin/pull-tutorial.sh https://raw.githubusercontent.com/statgenetics/statgen-courses/pull-tutorials/src/pull-tutorial.sh
RUN chmod a+x /usr/local/bin/pull-tutorial.sh

# Add notebook startup hook
# https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html#startup-hooks
RUN mkdir -p /usr/local/bin/start-notebook.d
RUN echo "#!/bin/bash\n/usr/local/bin/pull-tutorial.sh fastlmm-gcta" > /usr/local/bin/start-notebook.d/get-updates.sh
RUN chmod a+x /usr/local/bin/start-notebook.d/get-updates.sh

RUN chown jovyan.users -R /home/jovyan

USER jovyan
# Download data

RUN mkdir /home/jovyan/.work
RUN cd /home/jovyan/.works
RUN curl -s -o - http://statgen.us/files/plinkseq-data.tar.bz2 | tar jx