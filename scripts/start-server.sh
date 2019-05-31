#!/bin/bash

sleep infinity

echo "---Preparing Server---"
chmod -R 770 ${DATA_DIR}

echo "---Starting Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/mta