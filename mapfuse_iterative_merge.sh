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
echo "#####           ITERATIVE MERGING             #####"
echo
echo

read -e -p "Enter initial model:" initial_model
echo "Initial model: $initial_model"
echo
read -e -p "Enter SLAM cloud: " slam_model
echo "SLAM model: $slam_model"
echo

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

read -p "Number of initial guess clouds to merge: " initial_clouds
read -p "Number of SLAM clouds to merge: " slam_clouds
echo "Merging $initial_clouds initial guess clouds with $slam_clouds SLAM clouds...."
echo
echo
echo "Merge in which order?"
echo "[1]: Initial guess clouds first"
echo "[2]: SLAM clouds first"
echo "[3]: Alternating between initial guess and SLAM"
read -p "1,2 or 3?  " order
echo
echo
read -p "Enter Octomap resolution [m] (default 0.10):" octomap_resolution

trap 'kill $BGPID; exit' SIGINT

roslaunch mapfuse mapfuse_iterative.launch x:=$x y:=$y z:=$z r:=$r p:=$p yaw:=$yaw resolution:=octomap_resolution&
$BGPID=$!

sleep 5

echo "####################"
echo

if [[ $order = 1 ]]; then

    #add initial clouds
    for ((j= 1; j <= initial_clouds; j++))
    do 
        roslaunch mapfuse mapfuse_iterative_initial.launch initial:=$initial_model> /dev/null
        echo "Added initial guess cloud $j"
    done

    echo "Initial guess clouds done."
    echo "####################"


    #add SLAM clouds
    for ((i = 1; i <= slam_clouds; i++))
    do 
        roslaunch mapfuse mapfuse_iterative_slam.launch slam_cloud:=$slam_model > /dev/null
        echo "Added SLAM cloud $i"
    done

    echo "SLAM clouds done."
    echo "####################"

elif [[ $order = 2 ]]; then
    #add SLAM clouds
    for ((i = 1; i <= slam_clouds; i++))
    do 
        roslaunch mapfuse mapfuse_iterative_slam.launch slam_cloud:=$slam_model > /dev/null
        echo "Added SLAM cloud $i"
    done

    echo "SLAM clouds done."
    echo "####################"

    #add initial clouds
    for ((j= 1; j <= initial_clouds; j++))
    do 
        roslaunch mapfuse mapfuse_iterative_initial.launch initial:=$initial_model> /dev/null
        echo "Added initial guess cloud $j"
    done

    echo "Initial guess clouds done."
    echo "####################"
elif [[ $order = 3 ]]; then
    while [[ $initial_clouds != 0 || $slam_clouds != 0 ]]; 
    do
    if [[ $slam_clouds > 0 ]]; then
        roslaunch mapfuse mapfuse_iterative_slam.launch slam_cloud:=$slam_model> /dev/null
        ((slam_clouds--))
        echo "$slam_clouds SLAM clouds to go"
    fi

    if [[ $initial_clouds > 0 ]]; then
        roslaunch mapfuse mapfuse_iterative_initial.launch initial:=$initial_model> /dev/null
        ((initial_clouds--))
        echo "$initial_clouds initial guess clouds to go"
    fi
    done
else "Invalid number!"
fi


echo
echo "Merging done!"
echo

read -p "Save OctoMap? (y/n)" yn
case $yn in
    [Yy]* ) read -p "Insert OctoMap name: " name
			name=${name}.ot
			rosrun octomap_server octomap_saver -f $name 
			echo "OctoMap saved to $name";;
    [Nn]* ) echo "Not saving OctoMap.";;
    * ) echo "Please answer yes or no.";;
esac

wait


