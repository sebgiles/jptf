nvidia-docker run -d --rm --runtime=nvidia  \
    -p 8888:8888                            \
    -p 5900:5900                            \
    --name jupyter                          \
    -e NB_UID=1000 -e NB_GID=1000           \
    -e DISPLAY=$DISPLAY                     \
    -v ~/tfnb:/tf                           \
    -v /tmp/.X11-unix:/tmp/.X11-unix        \
    jptf:latest
