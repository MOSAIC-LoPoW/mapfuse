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
echo
read -p "Number of initial guess clouds: " initial_clouds
read -p "Number of SLAM clouds: " slam_clouds
echo "Merging $initial_clouds initial guess clouds with $slam_clouds SLAM clouds...."
echo
echo
echo "Merge in which order?"
echo "[1]: Initial guess clouds first"
echo "[2]: SLAM clouds first"
echo "[3]: Alternating between initial guess and SLAM"
read -p "1,2 or 3?  " order

trap 'kill $BGPID; exit' SIGINT

roslaunch octomap_merger merge_freiburg1_room.launch &
$BGPID=$!

echo "####################"
echo

if [[ $order = 1 ]]; then

    #add initial clouds
    for ((j= 1; j <= initial_clouds; j++))
    do 
        roslaunch octomap_merger freiburg1_initial_guess.launch > /dev/null
        echo "Added initial guess cloud $j"
    done

    echo "Initial guess clouds done."
    echo "####################"


    #add SLAM clouds
    for ((i = 1; i <= slam_clouds; i++))
    do 
        roslaunch octomap_merger freiburg1_rgbdslam.launch > /dev/null
        echo "Added SLAM cloud $i"
    done

    echo "SLAM clouds done."
    echo "####################"

elif [[ $order = 2 ]]; then
    #add SLAM clouds
    for ((i = 1; i <= slam_clouds; i++))
    do 
        roslaunch octomap_merger freiburg1_rgbdslam.launch > /dev/null
        echo "Added SLAM cloud $i"
    done

    echo "SLAM clouds done."
    echo "####################"

    #add initial clouds
    for ((j= 1; j <= initial_clouds; j++))
    do 
        roslaunch octomap_merger freiburg1_initial_guess.launch > /dev/null
        echo "Added initial guess cloud $j"
    done

    echo "Initial guess clouds done."
    echo "####################"
elif [[ $order = 3 ]]; then
    while [[ $initial_clouds != 0 || $slam_clouds != 0 ]]; 
    do
    if [[ $slam_clouds > 0 ]]; then
        roslaunch octomap_merger freiburg1_rgbdslam.launch > /dev/null
        ((slam_clouds--))
        echo "$slam_clouds SLAM clouds to go"
    fi

    if [[ $initial_clouds > 0 ]]; then
        roslaunch octomap_merger freiburg1_initial_guess.launch > /dev/null
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


