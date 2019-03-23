FROM tensorflow/tensorflow:latest-gpu-py3-jupyter
RUN pip3 install jupyter-tensorboard
RUN pip3 install numpy scipy matplotlib
RUN pip3 install pillow
RUN jupyter tensorboard enable
ENV JUPYTER_TOKEN 'seb'
