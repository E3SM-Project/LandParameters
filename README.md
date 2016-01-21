# LandParameters
Collaboration space for determining parameters for the Land model

# Creating CLM NetCDF parameter file 

`create_clm_parameter_netcdf.sh` creates a NetCDF file based on the parameter values 
in clm_params.txt.

## Requirements
- ncgen
- git

On Titan, Edision and Cori, `ncgen` and `git` can be added by loading the following modules:

- `module load cray-netcdf`
- `module load git`


## Runing the script

- Option-1: Create the parameter file with verbosity turned on (`-v`) and clean up temporary files at the end (`-c`)

```
./create_clm_parameter_netcdf.sh -v -c
Verbosity: On
 
Creating temporary ascii clm parameter file:
  cp clm_params.txt tmp_clm_params.8aacd22.2016-01-21_08-18-45.txt
 
Setting username in ascii clm parameter file  :  gbisht
Setting date in ascii clm parameter file      :  Thu Jan 21 08:18:45 PST 2016
Setting full_hash in ascii clm parameter file :  8aacd229292825ca089ff5f06cb96bccd7c14abb
 
Creating NetCDF clm parameter file:
  ncgen -b -o clm_params_8aacd22_c160121.nc -k netCDF-4 tmp_clm_params.8aacd22.2016-01-21_08-18-45.txt
 
Deleting the temporary ascii clm parameter file
``` 

- Option-2: Same as Option-1 plus specify the output filename (`-o|--output <filename>`)

```
./create_clm_parameter_netcdf.sh -v -c --output clm_params_for_v1.0.0alpha1.nc
Verbosity: On
 
Creating temporary ascii clm parameter file:
  cp clm_params.txt tmp_clm_params.8aacd22.2016-01-21_08-22-08.txt
 
Setting username in ascii clm parameter file  :  gbisht
Setting date in ascii clm parameter file      :  Thu Jan 21 08:22:08 PST 2016
Setting full_hash in ascii clm parameter file :  8aacd229292825ca089ff5f06cb96bccd7c14abb
 
Creating NetCDF clm parameter file:
  ncgen -b -o clm_params_for_v1.0.0alpha1.nc -k netCDF-4 tmp_clm_params.8aacd22.2016-01-21_08-22-08.txt
 
Deleting the temporary ascii clm parameter file
```
