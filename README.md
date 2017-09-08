# MapFuse
MapFuse is a solution to build complete, volumetric models of an environment. The environment has to be recorded with a Microsoft Kinect camera, to create a dataset which can be used for the RGB-D SLAM algorithm. The output of this algorithm is combined with an initial model of the environment in order to build a complete model.

## Prerequisites
* [RGB-D SLAM](https://github.com/felixendres/rgbdslam_v2)
* [OctoMap](https://github.com/OctoMap/octomap)

## Usage
Our approach fuses two point clouds into a single OctoMap. We propose two methods to merge SLAM point cloud with the initial model.

### Online merging
The online method merges the SLAM point cloud while it is still being built. We will demonstrate this with an example. First, download [this](https://vision.in.tum.de/rgbd/dataset/freiburg1/rgbd_dataset_freiburg1_room.tgz) RGB-D dataset. It will be used as input for the SLAM algorithm.



### Iterative merging
