SRC_DIR="$PWD/.."
TA_LOC=`cat loc_data.txt`
VIS_LOC=`cat loc_vis.txt`
H36M_LOC=`cat loc_h36m.txt`
TMP_LOC=`cat loc_tmp.txt`


cp Dockerfile Dockerfile.bkp

echo "RUN echo \"set password\"" >> Dockerfile

if [ -f "loc_data.txt" ]; then
	DATA_LOC=`cat loc_data.txt`
	echo "Human3.6M data location: $DATA_LOC: "
	echo "RUN python -c \"import mocap.settings as settings; settings.set_data_path('/home/user/data/')\"" >> Dockerfile
	if [ ! -d $DATA_LOC ]; then
		mkdir $DATA_LOC
	fi
else
	printf "\n\033[1;31mWARNING: data will be stored in the docker container. This may cause performance issues! CTRL-Z to end the process\n\033[0m"
	sleep 10
fi

echo "RUN python -c \"import mocap.settings as settings; settings.set_h36m_path('/home/user/data/human3.6m_original')\"" >> Dockerfile

echo "RUN adduser --disabled-password --gecos \"\" -u $UID user"  >> Dockerfile
echo "USER user" >> Dockerfile

./build.sh

rm Dockerfile
mv Dockerfile.bkp Dockerfile

docker run\
	--gpus all\
	--privileged\
    	--shm-size="8g"\
	-v "$SRC_DIR":/home/user/DMGNN\
	-v "$VIS_LOC":/home/user/visualize\
	-v "$PWD/data/tmp_spacepy":/home/user/.spacepy\
	-v "$TMP_LOC":/home/user/tmp\
	-v "$H36M_LOC":/home/user/data/human3.6m_original\
	-v "$DATA_LOC":/home/user/data\
    	--rm -it\
	jutanke/dmgnn\
    	/bin/bash

