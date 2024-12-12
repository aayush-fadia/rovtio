## Build Image
To build the image for ROVTIO, enter the command:
```bash
podman build --format dockerfile -t rovtio-dataset -f rovtio-dataset.dockerfile .
```
## Run Container
To run the container with:
* The dataset folder mounted in
* Ability to display RViz
 
Run:
```bash
podman run -it \                                                                                                         ✔  09:21:03 PM 
     --mount type=bind,source=<path_to_dataset_rosbags/>,destination=/dataset/ \
     --network host \
     -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
     -v /run/user/1000/:/run/user/1000/ \
     -e DISPLAY=$DISPLAY \
     -e XDG_RUNTIME_DIR=/run/user/1000 \
     --security-opt label=type:container_runtime_t \
     --ipc=host \
     rovtio-dataset:latest
```
## Run ROVTIO
To run ROVTIO, simply follow the instructions in the main README.

The rosbags are mounted at `/dataset/`.

Run `podman exec -it <container_name> bash` to open new terminals inside the container.