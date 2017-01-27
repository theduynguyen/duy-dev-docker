FROM nvidia/cuda:8.0-cudnn5-devel

ARG conda_version=Miniconda2-4.2.12
ARG tensorflow_version=0.12.1-cp27-none

# Conda
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

RUN mkdir -p $CONDA_DIR && \
    echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh && \
    apt-get update && \
    apt-get install -y wget git libhdf5-dev g++ graphviz && \
    wget --quiet https://repo.continuum.io/miniconda/${conda_version}-Linux-x86_64.sh && \
    echo "c8b836baaa4ff89192947e4b1a70b07e *${conda_version}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash /${conda_version}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm ${conda_version}-Linux-x86_64.sh

# Vim
RUN apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
    python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git && \
    apt-get remove vim vim-runtime gvim

RUN cd ~ && \
    git clone https://github.com/vim/vim.git && \
    cd vim && \
    ./configure --with-features=huge \
                --enable-multibyte \
                --enable-rubyinterp=yes \
                --enable-pythoninterp=yes \
                --with-python-config-dir=$CONDA_DIR/bin \
                --enable-python3interp=no \
                --enable-perlinterp=yes \
                --enable-luainterp=yes \
                --enable-gui=gtk2 --enable-cscope --prefix=/usr && \
    make VIMRUNTIMEDIR=/usr/share/vim/vim80 && \
    make install
COPY vimrc /home/deeplearner/.vimrc

# create directories /src, /data, /work for user and grant access to vimrc
ENV NB_USER deeplearner
ENV NB_UID 1000

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    chown -R deeplearner /home/deeplearner && \
    chown deeplearner /home/deeplearner/.vimrc && \
    mkdir -p $CONDA_DIR && \
    mkdir -p /src && \
    mkdir -p /data && \
    mkdir -p /work && \
    chown deeplearner $CONDA_DIR -R && \
    chown deeplearner /src && \
    chown deeplearner /data && \
    chown deeplearner /work

#########################################################################
USER deeplearner

# get trained model to avoid downloading them every time
RUN mkdir -p /home/deeplearner/.keras/models && \
    cd /home/deeplearner/.keras/models && \
    wget --quiet https://github.com/fchollet/deep-learning-models/releases/download/v0.2/resnet50_weights_tf_dim_ordering_tf_kernels.h5 && \
    wget --quiet https://github.com/fchollet/deep-learning-models/releases/download/v0.2/resnet50_weights_tf_dim_ordering_tf_kernels_notop.h5 && \
    wget --quiet https://github.com/fchollet/deep-learning-models/releases/download/v0.1/vgg16_weights_tf_dim_ordering_tf_kernels.h5 && \
    wget --quiet https://github.com/fchollet/deep-learning-models/releases/download/v0.1/vgg16_weights_tf_dim_ordering_tf_kernels_notop.h5

# Python env
RUN pip install https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-${tensorflow_version}-linux_x86_64.whl && \
    pip install ipdb pytest xmltodict pytest-cov python-coveralls coverage pytest-xdist pep8 pytest-pep8 pydot_ng jedi && \
    conda install Pillow scikit-image scikit-learn notebook pandas matplotlib nose pyyaml six h5py && \
    pip install keras && \
    conda clean -yt

ENV PYTHONPATH='/src/:$PYTHONPATH'
ENV PYTHONDONTWRITEBYTECODE=True

# Vim plugins
RUN chmod u+rw /home/deeplearner/.vimrc && \
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
    vim +PluginInstall +qall

# set current dir
WORKDIR /src

#Ports
# Tensorboard
EXPOSE 6006
#Jupyter notebook
EXPOSE 8888

# Start Jupyter notebook (can be overriden)
CMD jupyter notebook --port=8888 --no-browser --ip=0.0.0.0