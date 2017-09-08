# MapFuse
MapFuse is a solution to build complete, volumetric models of an environment. The environment has to be recorded with a Microsoft Kinect camera, to create a dataset which can be used for the RGB-D SLAM algorithm. The output of this algorithm is combined with an initial model of the environment in order to build a complete model.

## Prerequisites
* Ubuntu 16.04
* [ROS Kinetic](http://wiki.ros.org/kinetic/Installation/Ubuntu)
* [RGB-D SLAM](https://github.com/felixendres/rgbdslam_v2) This package is included in our repository, as well as its installation instructions.
* [OctoMap](http://wiki.ros.org/octomap)

## Installation
In order to work with MapFuse, we have to build a ROS workspace. Copy the ROS packages from <b>code/ros_catkin_ws/src/</b> in this repository in o your own ROS workspace. If you have already built RGB-D SLAM in your workspace, you only need to copy the mapfuse package. For more information on how to create your ROS workspace, check out [this link](http://wiki.ros.org/catkin/Tutorials/create_a_workspace). 
After copying the necessary packages into your ROS workspace, execute:
```
cd ~/catkin_ws/
catkin_make
```
Remember to source your ROS workspace when running the ROS nodes. We recommend that you specify this in your .bashrc file. If all prerequisites are installed correctly, and your ROS workspace is sourced, you should be able to proceed with MapFuse.
## Usage
Our approach fuses two point clouds into a single OctoMap. We propose two methods to merge SLAM point cloud with the initial model.

### Online merging
The online method merges the SLAM point cloud while it is still being built. We will demonstrate this with an example. First, download [this](https://vision.in.tum.de/rgbd/dataset/freiburg1/rgbd_dataset_freiburg1_room.tgz) RGB-D dataset. It will be used as input for the SLAM algorithm.


### Iterative merging
