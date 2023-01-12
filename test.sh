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

redis_connect_pool CONN_POOL FD AUTH "master" "mymaster" || errexit "redis_connect_pool failed"

declare -A CHANNELS
CHANNELS+=( [control]="callback_control" )
CHANNELS+=( [simplereader]="callback_simplereader" )

# Callbacks must be defined prior to calling redis_pubsub_subscribe
function callback_control()
{
	# Args: fd result_array channel message
	local fd=${1}; shift
	local tmpname=${1}; shift
	local channel=${1}; shift
	local message=${1}
	local msgarr=( ${message} )

	[ ${DEBUG} -ne 0 ] && echo "callback_control: channel=${channel} message=${message}"
	redis_sendrequest ${fd} "${msgarr[@]}"
	redis_getreply ${fd} "${tmpname}" || return 1
	return 0
}

function callback_simplereader()
{
	# Args: fd result_array channel message
	[ ${DEBUG} -ne 0 ] && echo "callback_simplereader: channel=${3} message=${4}"
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
