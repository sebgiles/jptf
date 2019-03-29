FROM tensorflow/tensorflow:1.13.0rc2-gpu-py3-jupyter
ENV DEBIAN_FRONTEND noninteractive
RUN touch /etc/pip.conf
ENV PIP_CONFIG_FILE=/etc/pip.conf
RUN echo $PIP_CONFIG_FILE
COPY 02proxy /etc/apt/apt.conf.d/
#ENV PIP_INDEX_URL "http://172.17.0.1:3141/root/pyp/i/+simple/"
RUN touch /etc/pip.conf
RUN echo "[global]" >> $PIP_CONFIG_FILE
RUN echo "extra-index-url = http://172.17.0.1:3141/root/pypi/+simple/" >> /etc/pip.conf
RUN echo "trusted-host = 172.17.0.1" >> /etc/pip.conf
Run apt install -y wget curl sudo
RUN wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb
RUN dpkg -i nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb
RUN rm nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb

ENV JUPYTER_TOKEN 'seb'
ENV JUPYTER_PASSWORD 'seb'

# USEFUL TO OPEN python scripts as notebooks
RUN pip3 install jupytext --upgrade

# TENSORBOARD INSTALL AND SETUP
RUN pip3 install jupyter-tensorboard
RUN jupyter tensorboard enable

# GENERIC TOOLS
RUN apt update; exit 0

# CUDNN, is this not already in the base image?
RUN apt install libcudnn7=7.4.1.5-1+cuda10.0

# GET THEM ML LIBS AND FRAMEWORKS
RUN pip3 install numpy scipy pillow matplotlib keras scikit-learn
RUN pip3 install h5py opencv-python scikit-image blosc pandas

# NEEDED for OPENAI GYM
RUN apt install -y cmake zlib1g-dev
# OPENAI GYM
RUN pip3 install atari-py==0.1.1 gym[atari]==0.9.1 gym[breakout-v0]

# NEEDED TO RENDER OPENAI GYM ENVIRONMENTS
RUN apt install -y libsm6 ffmpeg
#RUN apt install -y libjpeg-dev libav-tools xorg-dev
#RUN pip3 install PyOpenGL piglet pyglet JSAnimation ipywidgets

RUN apt-get install -y x11vnc xvfb fluxbox wmctrl
# VNC Server
EXPOSE 5900

# Enable jupyter widgets
#RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

ENV DEBIAN_FRONTEND teletype
#CMD ["bash", "-c", "source /etc/bash.bashrc && xvfb-run -s \"-screen 0 1400x900x24\" /usr/local/bin/jupyter notebook --notebook-dir=/tf --ip 0.0.0.0 --no-browser --allow-root"]
COPY startup.sh /
CMD ["bash", "-c", "/startup.sh", "--allow-root"]
