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
CONN_POOL+=( "192.168.122.100" "26379" )
CONN_POOL+=( "192.168.122.101" "26379" )
CONN_POOL+=( "192.168.122.102" "26379" )

AUTH=( [password]="A1B2C3" )

redis_connect_pool CONN_POOL FD AUTH "master" "mymaster"
declare -A CHANNELS
CHANNELS+=( [channel1]="callback_function1" )
CHANNELS+=( [channel2]="callback_function2" )

# Callbacks must be defined prior to calling redis_pubsub_subscribe
function callback_function1()
{
	# Args: channel message
	echo "callback_function1: $1 $2"
	return 0
}

function callback_function2()
{
	# Args: channel message
	echo "callback_function2: $1 $2"
	return 0
}

redis_pubsub_subscribe FD CHANNELS || errexit "redis_pubsub_subscribe failed"

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
#redis_client ${FD} "${tmpname}" GET "pbdu/server" || errexit "GET command failed"
#redis_strval ${tmpname} STR1 || errexit "redis_strval failed"
#echo "server is ${STR1}"

#tmpname="array_${RANDOM}"
#eval "declare -A ${tmpname}"
#[ ${DEBUG} -ne 0 ] && echo "Root array: ${tmpname}"
#redis_client ${FD} "${tmpname}" MGET key1 key2 nonexisting || errexit "MGET command failed"
#redis_strval ${tmpname} STR1 || errexit "redis_strval failed"

redis_disconnect ${FD}
