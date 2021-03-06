#!/bin/bash

# this function create a required directory. if fails the script exits with error level 2
# with '-d' flag try to remove the dir before creation
# with '-o' flag move to .old the prev. deploy and install the new
mkreqdir () {
    local d to_old

    to_old=0
    if [ $# -gt 1 -a "$1" = "-d" ]; then
        rm -rf "$2"
        shift
    elif [ $# -gt 1 -a "$1" = "-o" ]; then
        to_old=1
        shift
    fi
    d="$1"

    if [ $to_old -eq 1 ]; then
        if [ -d "$d" ]; then 
            if [ -d "${d}.old" ]; then 
	        rm -rf "${d}.old"
            fi 
            mv "${d}" "${d}.old"
        fi         
    fi

    if [ ! -d "$d" ]; then
        mkdir -p "$d"
    fi

    if [ ! -d "$d" ]; then
        echo "ERROR: '$d' dir creation failed" 
        exit 2
    fi
    return 0
}

#
#  MAIN
export GEM_PROJ=oq-ui-api
set | grep -q "^GEM_BASEDIR=" || export GEM_BASEDIR="/var/lib/openquake/"
set | grep -q "^GEM_OQ_UI_API_GIT_VERS=" || export GEM_OQ_UI_API_GIT_VERS="HEAD"
set | grep -q "^MKREQDIR_ARG=" || export MKREQDIR_ARG="-o"

if [ "$1" = "deploy" ]; then
    mkreqdir ${MKREQDIR_ARG} "${GEM_BASEDIR}${GEM_PROJ}"

    git archive $GEM_OQ_UI_API_GIT_VERS | tar -x -C "$GEM_BASEDIR${GEM_PROJ}"
    ln -sf "${GEM_BASEDIR}${GEM_PROJ}"/geonode/geodetic     /var/lib/geonode/src/GeoNodePy/geonode/geodetic
    ln -sf "${GEM_BASEDIR}${GEM_PROJ}"/geonode/isc_viewer   /var/lib/geonode/src/GeoNodePy/geonode/isc_viewer
    ln -sf "${GEM_BASEDIR}${GEM_PROJ}"/geonode/observations /var/lib/geonode/src/GeoNodePy/geonode/observations
    ln -sf "${GEM_BASEDIR}${GEM_PROJ}"/geonode/ged4gem      /var/lib/geonode/src/GeoNodePy/geonode/ged4gem

    cp -r etc/geonode/ /etc/

    source /var/lib/geonode/bin/activate
    cd /var/lib/geonode/src/GeoNodePy/geonode/
    python ./manage.py collectstatic --noinput >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo
        echo "'python ./manage.py collectstatic --noinput' command failed."
        echo "Try 'sudo make fix' and run 'sudo make deploy' again."
        echo
        exit 1
    fi
fi

exit 0
