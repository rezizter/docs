#!/usr/bin/env bash

# This will delete and recreate the python virtual env
# for the current user, for our mobile-ansible-core project.

# It will be created in .cache/venv/mobile-ansible-core-x.x, where x.x
# is the python major version number.

venv_root="${HOME}/.cache/venv"
project_name='mobile-ansible-core'

#################
# detect python #
#################

if [ -n "${VIRTUAL_ENV}" ]
then
    echo "A python venv was detected."
    echo "Please manually deactivate your python venv"
    echo "before running this script via the \"deactivate\" command."
    exit 1
fi

if type python > /dev/null 2>&1
then
    python_maj_ver=$(python -V 2>&1 | awk  '{print $2}' | awk -F '.' '{print $1"."$2}')
fi

if type python3 > /dev/null 2>&1
then
    python3_maj_ver=$(python3 -V | awk  '{print $2}' | awk -F '.' '{print $1"."$2}')
fi

if ! echo "${python_maj_ver}" | grep -E ^3 > /dev/null 2>&1
then
    if ! echo "${python3_maj_ver}" | grep -E ^3 > /dev/null 2>&1
    then
        echo "rpv: Failed to detect any python binary of version 3.x"
        exit 0
    else
        pybin="python3"
    fi
else
    pybin="python"

fi

py_maj_ver=$("$pybin" -V | awk  '{print $2}' | awk -F '.' '{print $1"."$2}')
pvenv="${venv_root}/${project_name}-${py_maj_ver}"

#################
# sanity checks #
#################

if ! git remote -v|grep "${git_host}" | grep "${git_ansible_core}" \
                                             > /dev/null 2>&1
then
    echo "rpv: You don't appear to be in the mobile-ansible-core git project."
    exit 1
fi

if ! [ -f roles_external/requirements.yml ]
then
    echo "rpv: 'roles_external/requirements.yml' not found."
    echo "rpv: Are you in the home dir of the git repo?"
    exit 1
fi

if ! curl -Is http://www.google.com | head -1 | grep 200 > /dev/null 2>&1
then
    echo "rpv: Your internet connection is not 100%."
    exit 1
fi

if ! echo "rpv: ${pvenv}" | grep venv  > /dev/null 2>&1
then
    echo "rpv: Directory detected to delete does not contain 'venv'"
    echo "rpv: Directory detected is [${pvenv}]"
    echo "rpv: Not proceeding further with deletion"
    exit 1
fi

########
# main #
########

echo "rpv: Deleting your ${project_name} venv and recreating it."

echo "rpv: Deleting \"${pvenv}\" directory."
if ! rm -rf "${pvenv}"
then
    echo "rpv: Failed to delete \"${pvenv}\" directory"
    exit 1
fi
echo "rpv: Deleted ${project_name} venv."

echo "rpv: Creating python venv @ \"${pvenv}\"."
if ! "${pybin}" -m venv "${pvenv}"
then
    echo "rpv: Failed to create venv @ \"${pvenv}\"."
    exit 1
fi
echo "rpv: Created python venv @ \"${pvenv}\"."

if ! source "${pvenv}/bin/activate"
then
    echo "rpv: Failed to activate venv."
    exit 1
fi

echo "rpv: Upgrading pip."
echo '----------'
if ! pip install --upgrade pip
then
    echo "rpv: Failed to upgrade pip, exiting."
    exit 1
fi
echo '----------'
echo "rpv: Pip upgraded."

echo "rpv: Fetching python requirements."
echo '----------'
if ! pip install -r requirements.txt
then
    # TODO: I need this hack on guix for some reason.
    if ! python3 -m pip install -r requirements.txt
    then
        echo "rpv: Failed to fetch python requirements."
        exit 1
    fi
fi
echo '----------'
echo "rpv: Python requirements fetched."

# TODO: Why do we do this again?
echo "rpv: Applying hack for pycurl."
echo '----------'
if ! pip uninstall -y pycurl
then
    # TODO: I need this hack on guix for some reason.
    if ! python3 -m pip uninstall -y pycurl
    then
        echo  "Failed to uninstall pycurl"
        exit 1
    fi
fi

export PYCURL_SSL_LIBRARY=nss
if ! pip install --compile --install-option="--with-nss" --no-cache-dir pycurl
then
    # TODO: I need this hack on guix for some reason.
    if ! python3 -m pip install --compile --install-option="--with-nss" --no-cache-dir pycurl
    then
        echo "rpv: Failed to compile pycurl with nss."
        exit 1
    fi
fi
echo '----------'
echo "rpv: Hack applied for pycurl."

echo "rpv: Activating new venv."
echo "rpv: Nev venv created and activated."
echo 'rpv: new versions details:'
echo '----------'
python3 --version
ansible --version
ansible-lint --version
yamllint --version
molecule --version
echo '----------'
echo "rpv: All done!"
