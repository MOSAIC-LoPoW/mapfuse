#!/bin/bash
echo
echo "###################################################"
echo
echo "     ##   ##   #   ####  ##### #  # #### #####"
echo "     # # # #  # #  #   # #     #  # #    #"
echo "     #  #  # ##### ####  ###   #  # #### ###  " 
echo "     #     # #   # #     #     #  #    # #"
echo "     #     # #   # #     #     #### #### #####  "
echo
echo "###################################################"
echo "michiel.aernouts@uantwerpen.be"
echo 
echo
echo "#####             ONLINE MERGING              #####"
echo
echo
echo "You can change RGB-D SLAM parameters in the mapfuse_online.launch file"
echo
echo "When merging is done, save the map by running: "
echo "rosrun octomap_server octomap_saver -f <name>.ot"
echo
echo
echo "##########################################"
echo
read -e -p "Enter initial model:" initial_model
echo "Initial model: $initial_model"
echo
read -e -p "Enter bagfile location: " bagfile
echo "Rosbag: $bagfile"
echo
read -p "Bagfile playback speed: " bagspeed

read -p "Align x y z r p yaw? (Default is 0 0 0 0 0 0) (y/n) " yn
case $yn in
    [Yy]* ) read -p "x:" x
            read -p "y:" y
            read -p "z:" z
            read -p "r:" r
            read -p "p:" p
            read -p "yaw:" yaw
            echo "Alignment set to: $x $y $z $r $p $yaw";;
    [Nn]* ) x=0
            y=0
            z=0
            r=0
            p=0
            yaw=0
            echo "Alignment set to: $x $y $z $r $p $yaw";;
    * ) echo "Please answer yes or no.";;
esac
echo
echo
read -p "Enter Octomap resolution [m] (default 0.10):" octomap_resolution
echo
echo

trap 'kill $BGPID; exit' SIGINT

roslaunch mapfuse mapfuse_online.launch initial:=$initial_model bag:=$bagfile speed:=$bagspeed x:=$x y:=$y z:=$z r:=$r p:=$p yaw:=$yaw resolution:=octomap_resolution&
$BGPID=$!

echo "####################"
echo

read -p "Save OctoMap? (Press y or n when merging is done)" yn
case $yn in
    [Yy]* ) read -p "Insert OctoMap name: " name
			name=${name}.ot
			rosrun octomap_server octomap_saver -f $name 
			echo "OctoMap saved to $name";;
    [Nn]* ) echo "Not saving OctoMap.";;
    * ) echo "Please answer yes or no.";;
esac

wait


