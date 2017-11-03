# MapFuse
MapFuse is a solution to build complete, volumetric models of an environment. The environment has to be recorded with a Microsoft Kinect camera, to create a dataset which can be used for the RGB-D SLAM algorithm. The output of this algorithm is combined with an initial model of the environment in order to build a complete model.

## Prerequisites
* Ubuntu 16.04
* [ROS Kinetic](http://wiki.ros.org/kinetic/Installation/Ubuntu)
* [RGB-D SLAM](https://github.com/felixendres/rgbdslam_v2) (Installation instructions below.)
* [ros-kinetic-octomap](http://wiki.ros.org/octomap)

## Installation
* Run **install_rgbdslam.sh**. This creates a new folder called */mapfuse* in your home directory, containing a ROS workspace with RGB-D SLAM up and running. If you want to install the ROS workspace somewhere else, change it in the install_rgbdslam.sh executable.
* Open the */ros* folder from this repository. Copy the entire **/mapfuse** folder from the */ros* folder to the ROS workspace that contains RGB-D SLAM (*e.g. ~/mapfuse/catkin_ws/src*)
* Build your ROS workspace. E.g.:
	```
	cd ~/mapfuse/catkin_ws
	catkin_make
	```
* Source your ROS workspace. In a terminal, execute: **source ~/mapfuse/catkin_ws/devel/setup.bash**. You can add this command to *.bashrc* if you don't want to repeat this command every time you open a new terminal.


## Usage
Our approach fuses two point clouds into a single OctoMap. We propose two methods to merge SLAM point cloud with the initial model.

### Online merging
The online method merges the SLAM point cloud while it is still being built. We will demonstrate this with an example. First, download [this](https://vision.in.tum.de/rgbd/dataset/freiburg1/rgbd_dataset_freiburg1_room.bag) RGB-D dataset. It will be used as input for the SLAM algorithm.


### Iterative merging
