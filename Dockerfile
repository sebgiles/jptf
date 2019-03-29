FROM tensorflow/tensorflow:1.13.0rc2-gpu-py3-jupyter
ENV DEBIAN_FRONTEND noninteractive

RUN apt update

ENV JUPYTER_TOKEN 'seb'
ENV JUPYTER_PASSWORD 'seb'

# USEFUL TO OPEN python scripts as notebooks
RUN pip3 install jupytext --upgrade

# TENSORBOARD INSTALL AND SETUP
RUN pip3 install jupyter-tensorboard
RUN jupyter tensorboard enable

# GENERIC TOOLS
RUN apt install -y curl wget sudo

# CUDNN, is this not already in the base image?
RUN apt install libcudnn7=7.4.1.5-1+cuda10.0

# GET THEM ML LIBS AND FRAMEWORKS
RUN pip3 install numpy scipy pillow matplotlib keras scikit-learn
RUN pip3 install h5py opencv-python scikit-image blosc pandas

# NEEDED for OPENAI GYM
RUN apt install -y cmake zlib1g-dev libjpeg-dev xvfb libav-tools xorg-dev
RUN pip3 install PyOpenGL piglet pyglet JSAnimation ipywidgets
# OPENAI GYM
RUN pip3 install atari-py==0.1.1 gym[atari]==0.9.1 gym[breakout-v0]

# NEEDED TO RENDER OPENAI GYM ENVIRONMENTS
RUN apt install -y libsm6 ffmpeg

################### SSH #######################
RUN apt install -y openssh-server

RUN mkdir /var/run/sshd
RUN echo 'root:seb' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
################################################

############# X11 FORWARDING TEST ###############
RUN apt install -y firefox

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
