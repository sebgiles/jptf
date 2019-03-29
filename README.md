# jptf
docker image with python3, jupyter, tensorflow-gpu, jupyter-tensorboard and more
#### Requirements on host:
- nvidia drivers (tested on GTX 1050Ti Notebook):

`sudo apt update`

`sudo apt purge nvidia*`

`sudo apt install nvidia-415`

- nvidia-docker

`sudo apt install nvidia-docker2`

#### Install image:

- Prepare Jupyter notebook root directory:

`cd ~`

`mkdir tfnb #put .ipynb files in here`

- Clone this repo:

`git clone https://github.com/sebgiles/jptf.git`

- Build 

`nvidia-docker built -t jptf jptf`

`chmod +x jptf/jptf.sh`

- Run

`./jptf/jptf.sh`

