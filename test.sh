#!/bin/bash
#set -vx
#REDIS_HOST=192.168.122.100
#REDIS_PORT=6379

function errexit {
	echo "${1}" 2>/dev/stderr
	exit 1
}

source /home/pbd/redis-bash/redis-bash-lib

#declare -A CONN=( [host]="${REDIS_HOST}" [port]="${REDIS_PORT}" )
#redis_connect CONN FD

CONN_POOL=( )
CONN_POOL+=("10.0.0.11" "26379")
CONN_POOL+=("10.0.0.13" "26379")
CONN_POOL+=("10.0.0.16" "26379")

AUTH=( [password]="A1B2C3" )

redis_connect_pool CONN_POOL FD AUTH "master" "mymaster"

#tmpname="array_${RANDOM}"
#eval "declare -A ${tmpname}"
#[ ${DEBUG} -ne 0 ] && echo "Root array: ${tmpname}"
#redis_client ${FD} "${tmpname}" AUTH A1B2C3 || errexit "AUTH command failed"
#declare -p tmpname

#set -x
#redis_strval ${tmpname} STR1 || errexit "redis_strval failed"
#set +x

#tmpname="array_${RANDOM}"
#eval "declare -A ${tmpname}"
#[ ${DEBUG} -ne 0 ] && echo "Root array: ${tmpname}"
#redis_client ${FD} "${tmpname}" ROLE || errexit "ROLE command failed"
#declare -p tmpname

#set -x
#redis_strval ${tmpname} STR1 2 1 0 || errexit "redis_strval failed"
#set +x
#echo "ip is ${STR1}"

#tmpname="array_${RANDOM}"
#eval "declare -A ${tmpname}"
#[ ${DEBUG} -ne 0 ] && echo "Root array: ${tmpname}"
#redis_client ${FD} "${tmpname}" SET "pbdu/server" "ltsp-2.xephon2.test" || errexit "SET command failed"

#tmpname="array_${RANDOM}"
#eval "declare -A ${tmpname}"
#[ ${DEBUG} -ne 0 ] && echo "Root array: ${tmpname}"
#redis_client ${FD} "${tmpname}" GET "pbdu/server" || errexit "SET command failed"
#redis_strval ${tmpname} STR1 || errexit "redis_strval failed"
#echo "server is ${STR1}"

redis_disconnect ${FD}

