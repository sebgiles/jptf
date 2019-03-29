nvidia-docker run -it --rm --runtime=nvidia -p 8888:8888 -e DISPLAY=$DISPLAY -v ~/tfnb:/tf -v /tmp/.X11-unix:/tmp/.X11-unix jptf
