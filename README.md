# Multi Theft Auto in Docker optimized for Unraid

This Docker will download and install Multi Theft Auto

Initial Servername: "Docker MTA Server" Password: "Docker"

If you want to connect to the console open a terminal and enter 'docker exec -u mta -ti NAMEOFYOURCONTAINER screen -xS MTA' (without quotes), to disconnect close the window.

**UPDATE NOTICE:** You can Force Update this Container (please note that you have to set Download Resources to 'true' and leave Skip Basicconfiguration blank to download everything new). 

## Env params

| Name | Value | Example |
| --- | --- | --- |
| SERVER_DIR | Folder for gamefiles | /serverdata/serverfiles |
| GAME_PARAMS | Commandline startup parameters | blank |
| SKIP_BASECONFIG_CHK | Set to 'true' (without quotes) to skip the download of the Basic Configuration files. | blank |
| DOWNLOAD_RESOURCES | Set to 'true' (without quotes) to download the resources, otherwise leave blank. | true |
| FORCE_UPDATE | Set to 'true' (without quotes) to redownload the whole server (please note that you have to set Download Resources to 'true' and leave Skip Basicconfiguration blank to download everything new).  | blank |
| LOGFILE_DIR | Change only if you know what you are doing. | multitheftauto_linux_x64/mods/deathmatch/logs/server.log |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |

# Run example
```
docker run --name MTA -d \
    -p 22003:22003/udp -p 22126:22126/udp -p 22005:22005 \
    --env 'DOWNLOAD_RESOURCES=true' \
    --env 'LOGFILE_DIR=multitheftauto_linux_x64/mods/deathmatch/logs/server.log' \
    --env 'UID=99' \
    --env 'GID=100' \
    --volume /path/to/mta:/serverdata/serverfiles \
    --restart=unless-stopped \
    ich777/ich777/mtaserver
```

This Docker was mainly created for the use with Unraid, if you don’t use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/