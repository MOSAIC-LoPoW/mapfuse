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
Our approach fuses two point clouds into a single OctoMap. We propose two methods to merge SLAM point cloud with the initial model. Both methods will be demonstrated using an open source RGB-D dataset.

### Online merging
The online method merges the SLAM point cloud while it is still being built. We will demonstrate this with an example. 
* First, download [this](https://vision.in.tum.de/rgbd/dataset/freiburg1/rgbd_dataset_freiburg1_room.bag) RGB-D dataset. It will be used as input for the SLAM algorithm.
* When the *.bag* file is downloaded, run **./mapfuse_online_merge.sh**.
* You are prompted to enter the file location of an initial point cloud. For this example, you can find the point cloud at */initial_guess_models/freiburg1/freiburg1_no_ceiling.pcd*
* Next, enter the file location of the bagfile that you just downloaded.
* Enter the speed at which the bagfile has to be played out (1 = real time)
* The initial point cloud has to be aligned with the RGB-D SLAM output to get a realistic model. For this example, the parameters are (roughly):
	```
	x: -2.2
	y 2.45
	z: 0
	r: -1.57
	p: 0
	yaw: 0
	```
* Enter the octomap resolution (default is 0.10)

After the resolution is set, MapFuse will start merging the point clouds. You will be able to see the process in Rviz, which opens automatically. For this example, you have to change the *Fixed Frame* in Rviz to */world*, and add an *OccupancyGrid* that listens to the */octomap_full* topic.

The result can be saved to an .ot file by opening a new terminal and executing: **rosrun octomap_server octomap_saver -f result.ot**.

### Iterative merging
The iterative method merges a finished SLAM point cloud with an initial point cloud. You can choose how many of each has to be included in the result, and in what order.
* Run **./mapfuse_iterative_merge.sh**.
* You are prompted to enter the file location of an initial point cloud. For this example, you can find the point cloud at */initial_guess_models/freiburg1/freiburg1_no_ceiling.pcd*
* Next, you are prompted to enter the file location of an SLAM point cloud. For this example, we have included a finished point cloud of the *freiburg_room1* dataset. You can find it at */examples/SLAM/freiburg_rgbdslam_pointcloud.pcd*
* The initial point cloud has to be aligned with the RGB-D SLAM output to get a realistic model. For this example, the parameters are (roughly):
	```
	x: 3.3
	y: 2.5
	z: 0
	r: 0
	p: -1.57
	yaw: 0.125
	```
* Enter the amount of initial clouds that you want to include in the result.
* Enter the amount of SLAM clouds that you want to include in the result.
* Select in which order you want to merge the clouds
..1. All initial clouds first
..2. All SLAM clouds first
..3. Alternating between initial clouds and SLAM clouds
* Enter the octomap resolution (default is 0.10)

After the resolution is set, MapFuse will start merging the point clouds. You will be able to see the process in Rviz, which opens automatically. For this example, you have to change the *Fixed Frame* in Rviz to */map*, and add an *OccupancyGrid* that listens to the */octomap_full* topic.

When merging is done, you are prompted to save the octomap to an .ot file.