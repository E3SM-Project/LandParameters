#!/bin/bash
#
# Creates a NetCDF CLM parameter file using values
# stored in clm_params.txt.
#
# Output: clm_params_<git_hash>_cYYMMDD.nc
#
# Author: Gautam Bisht, LBNL
#

output_filename=
verbose=0
cleanup=0

##################################################
# The command line help
##################################################
display_help() {
    echo "Usage: $0 " >&2
    echo
    echo "   -o, --output  <netcdf_filename>      Specify filename for the CLM parameter netcdf"
    echo "   -h, --help                           Display this message"
    echo "   -v, --verbose                        Set verbosity option true"
    echo "   -c, --cleanup                        Removes temporary file"
    echo
    exit 1
}


##################################################
# Get command line arguments
##################################################
while [ $# -gt 0 ]
do
  case "$1" in
    -o | --output ) output_filename="$2"; shift ;;
    -c | --cleanup) cleanup=1;;
    -v | --verbose) verbose=1;;
    -*)
      display_help
      exit 0
      ;;
    -h | --help)
      display_help
      exit 0
      ;;
    *)  break;;	# terminate while loop
  esac
  shift
done

if [ $verbose -eq 1 ]
then
  echo "Verbosity: On"
  echo " "
fi

# Checking if git and ncgen are available
command -v git >/dev/null   2>&1 || { echo "Require git but it's not installed.  Aborting." >&2; exit 1; }
command -v ncgen >/dev/null 2>&1 || { echo "Require ncgen but it's not installed.  Aborting." >&2; exit 1; }

# Define local variables
date_txt=`date`
date_YYMMDD=`date "+%y%m%d"`
date_YYYYMMDD_HHMMSS=`date "+%Y-%m-%d_%H-%M-%S"`
full_hash=`git log -n 1 --format=%H`
abbv_hash=`git log -n 1 --format=%h`

# Name of the temporary ascii clm parameter file
tmp_params_fname=tmp_clm_params.${abbv_hash}.${date_YYYYMMDD_HHMMSS}.txt

# Make a copy of the clm parameter file
cmd="cp clm_params_newcrops.txt ${tmp_params_fname}"
eval ${cmd}
if [ $verbose -eq 1 ]
then
  echo "Creating temporary ascii clm parameter file:"
  echo " " ${cmd}
  echo " "
fi

# Update following information in the temporary ascii parameter file
#  - user id
#  - date
#  - git hash
perl -w -i -p -e "s@__USERNAME__@$USER@"     ${tmp_params_fname}
if [ $verbose -eq 1 ]
then
  echo "Setting username in ascii clm parameter file  : " $USER
fi

perl -w -i -p -e "s@__DATE__@$date_txt@"     ${tmp_params_fname}
if [ $verbose -eq 1 ]
then
  echo "Setting date in ascii clm parameter file      : " $date_txt
fi

perl -w -i -p -e "s@__HASH__@$full_hash@"    ${tmp_params_fname}
if [ $verbose -eq 1 ]
then
  echo "Setting full_hash in ascii clm parameter file : " $full_hash
fi

# Create the netcdf file using the temporary ascii clm parameter file

if [ -z $output_filename ]; then
  output_filename=clm_params_${abbv_hash}_c${date_YYMMDD}.nc
fi

cmd="ncgen -b -o $output_filename -k classic ${tmp_params_fname}"
eval ${cmd}
if [ $verbose -eq 1 ]
then
  echo " "
  echo "Creating NetCDF clm parameter file:"
  echo " " ${cmd}
  echo " "
fi

# Delete the temporary parameter file, if so requested
if [ $cleanup -eq 1 ]
then
  cmd="rm -f ${tmp_params_fname}"
  eval ${cmd}
  if [ $verbose -eq 1 ]
  then
    echo "Deleting the temporary ascii clm parameter file"
    echo " "
  fi
fi

