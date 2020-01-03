#!/bin/bash
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}
if [ "${FORCE_UPDATE}" = "true" ]; then
	echo "---Force Update activated---"
    echo "---Downloading MTA---"
	cd ${SERVER_DIR}
   	if wget -q -nc --show-progress --progress=bar:force:noscroll http://linux.mtasa.com/dl/multitheftauto_linux_x64.tar.gz ; then
    	echo "---Successfully downloaded MTA---"
	else
    	echo "---Can't download MTA putting server into sleep mode---"
        sleep infinity
	fi
	tar --overwrite -xf multitheftauto_linux_x64.tar.gz
    rm ${SERVER_DIR}/multitheftauto_linux_x64.tar.gz
    if [ "${SKIP_BASECONFIG_CHK}" != "true" ]; then
        echo "---Downloading Baseconfig---"
        cd ${SERVER_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll http://linux.mtasa.com/dl/baseconfig.tar.gz ; then
        	echo "---Successfully downloaded Baseconfig---"
		else
        	echo "---Can't download Baseconfig putting server into sleep mode---"
            sleep infinity
		fi
        tar -xf baseconfig.tar.gz
        rm ${SERVER_DIR}/baseconfig/mtaserver.conf
        cp -R ${SERVER_DIR}/baseconfig/* ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch
        rm -R ${SERVER_DIR}/baseconfig
        rm ${SERVER_DIR}/baseconfig.tar.gz
        if [ ! -f ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/mtaserver.conf ]; then
        	cd ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch
        	if wget -q -nc --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/ich777/docker-mta-server/master/config/mtaserver.conf ; then
            	echo "---Successfully downloaded 'mtaserver.conf'---"
            else
            	echo "---Can't download 'mtaserver.conf' putting server into sleep mode---"
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
    	if wget -q -nc --show-progress --progress=bar:force:noscroll http://mirror.mtasa.com/mtasa/resources/mtasa-resources-latest.zip ; then
        	echo "---Successfully downloaded Resources---"
        else
        	echo "---Can't download Resources putting server into sleep mode---"
            sleep infinity
        fi
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
   	if wget -q -nc --show-progress --progress=bar:force:noscroll http://linux.mtasa.com/dl/multitheftauto_linux_x64.tar.gz ; then
    	echo "---Successfully downloaded MTA---"
	else
    	echo "---Can't download MTA putting server into sleep mode---"
        sleep infinity
	fi
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
        if wget -q -nc --show-progress --progress=bar:force:noscroll http://linux.mtasa.com/dl/baseconfig.tar.gz ; then
        	echo "---Successfully downloaded Baseconfig---"
		else
        	echo "---Can't download Baseconfig putting server into sleep mode---"
            sleep infinity
		fi
		tar -xf baseconfig.tar.gz
        cp -R ${SERVER_DIR}/baseconfig/* ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch
        rm -R ${SERVER_DIR}/baseconfig
        rm ${SERVER_DIR}/baseconfig.tar.gz
        cd ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch
        rm ${SERVER_DIR}/multitheftauto_linux_x64/mods/deathmatch/mtaserver.conf
        if wget -q -nc --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/ich777/docker-mta-server/master/config/mtaserver.conf ; then
           	echo "---Successfully downloaded 'mtaserver.conf'---"
        else
           	echo "---Can't download 'mtaserver.conf' putting server into sleep mode---"
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
    	if wget -q -nc --show-progress --progress=bar:force:noscroll http://mirror.mtasa.com/mtasa/resources/mtasa-resources-latest.zip ; then
        	echo "---Successfully downloaded Resources---"
        else
        	echo "---Can't download Resources putting server into sleep mode---"
            sleep infinity
        fi
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
screen -S MTA -d -m ${SERVER_DIR}/multitheftauto_linux_x64/mta-server64
sleep 5
tail -F ${SERVER_DIR}/${LOGFILE_DIR}