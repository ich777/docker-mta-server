#!/bin/bash
if [ "${FORCE_UPDATE}" = "true" ]; then
	echo "---Force Update activated---"
    echo "---Downloading MTA---"
	cd ${SERVER_DIR}
   	wget -qi multitheftauto_linux_x64.tar.gz http://linux.mtasa.com/dl/multitheftauto_linux_x64.tar.gz
	tar --overwrite -xf multitheftauto_linux_x64.tar.gz
    rm ${SERVER_DIR}/multitheftauto_linux_x64.tar.gz
    if [ "${SKIP_BASECONFIG_CHK}" != "true" ]; then
        echo "---Downloading Baseconfig---"
        cd ${SERVER_DIR}
        wget -qi baseconfig.tar.gz http://linux.mtasa.com/dl/baseconfig.tar.gz
        tar -xf baseconfig.tar.gz
        rm ${SERVER_DIR}/baseconfig/mtaserver.conf
        cp -R ${SERVER_DIR}/baseconfig/* ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch
        rm -R ${SERVER_DIR}/baseconfig
        rm ${SERVER_DIR}/baseconfig.tar.gz
        if [ ! -f ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/mtaserver.conf ]; then
        	cd ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch
        	wget -qi mtaserver.conf https://raw.githubusercontent.com/ich777/docker-mta-server/master/config/mtaserver.conf
        	if [ ! -f ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/mtaserver.conf ]; then
        		echo "---Something went wrong, can't download 'mtaserver.conf'---"
            	sleep infinity
        	fi
        fi
    else
    	echo "---Baseconfig download skipped---"
    fi
    if [ "${DOWNLOAD_RESOURCES}" = "true" ]; then
    	echo "---Downloading Resources---"
        if [ ! -d ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/resources ]; then
            mkdir ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/resources
        fi
    	cd ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/resources
    	wget -qi mtasa-resources-latest.zip http://mirror.mtasa.com/mtasa/resources/mtasa-resources-latest.zip
    	unzip -o mtasa-resources-latest.zip
    	rm ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/resources/mtasa-resources-latest.zip
    else
    	echo "---Resources download skipped---"
	fi
fi



echo "---Checking if MTA is installed---"
if [ ! -d ${SERVER_DIR}/multitheftauto_linux_x64 ]; then
	echo "---MTA not found, downloading---"
    cd ${SERVER_DIR}
    wget -qi multitheftauto_linux_x64.tar.gz http://linux.mtasa.com/dl/multitheftauto_linux_x64.tar.gz
	tar -xf multitheftauto_linux_x64.tar.gz
    rm ${SERVER_DIR}/multitheftauto_linux_x64.tar.gz
else
	echo "---MTA found!---"
fi

if [ "${SKIP_BASECONFIG_CHK}" != "true" ]; then
	echo "---Checking for Baseconfig---"
	if [ ! -f ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/mtaserver.conf ]; then
		echo "---Baseconfig not found, downloading---"
        cd ${SERVER_DIR}
		wget -qi baseconfig.tar.gz http://linux.mtasa.com/dl/baseconfig.tar.gz
		tar -xf baseconfig.tar.gz
        cp -R ${SERVER_DIR}/baseconfig/* ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch
        rm -R ${SERVER_DIR}/baseconfig
        rm ${SERVER_DIR}/baseconfig.tar.gz
        cd ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch
        rm ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/mtaserver.conf
        wget -qi mtaserver.conf https://raw.githubusercontent.com/ich777/docker-mta-server/master/config/mtaserver.conf
        if [ ! -f ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/mtaserver.conf ]; then
        	echo "---Something went wrong, can't download 'mtaserver.conf'---"
            sleep infinity
        fi
    else
    	echo "---Baseconfig found!---"
    fi
else
	echo "---Skipping Baseconfig check---"
fi

if [ "${DOWNLOAD_RESOURCES}" = "true" ]; then
	echo "---Checking for Resources---"
    if [ ! -d ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/resources ]; then
    	mkdir ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/resources
        cd ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/resources
        wget -q mtasa-resources-latest.zip http://mirror.mtasa.com/mtasa/resources/mtasa-resources-latest.zip
        unzip -o mtasa-resources-latest.zip
        rm ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/resources/mtasa-resources-latest.zip
    fi
else
	echo "---Resource Download skipped---"
fi
echo "---Preparing Server---"
chmod -R 770 ${DATA_DIR}

echo "---Starting Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/multitheftauto_linux_x64/mta-server64