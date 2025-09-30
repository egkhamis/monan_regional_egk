# Scripts MONAN-Regional | MPAS-Limited Area Regional Model

The MONAN-Regional is the mode of the MONAN-MPAS-Atmosphere that allows running the model not on the entire globe, but only over a limited area chosen by the user.

# How works

- You always start from a global mesh (grid.nc).
- A region is defined (via a .pts file, or by startlat/startlon/endlat/endlon).
- The MPAS-Limited-Area tools cut out the sub-mesh, generating a new regional grid.
- The resulting setup requires:
        static.nc → invariant/static fields for the region only.
        init.nc → initial conditions interpolated to the regional mesh.
        bdy.nc → time-varying lateral boundary conditions.

# Advantages

- Reduces computational cost (no need to run the whole globe).
- Each region has individual NWP needs.
- Physical processes of different scales act differently in each region.
- Collaboration in the exchange of information about the skill of the MONAN model for each region.
- Collaboration between meteorological centers, universities, companies, etc.
- Allows high-resolution simulations locally without wasting resources globally.

# Steps for execution on the Egeon Cluster

## 1. Download Structure of the MONAN-Regional

```
$ cd /mnt/beegfs/<sua_conta>
$ git clone https://github.com/egkhamis/monan_regional_egk.git
$ cd monan_regional_egk
$ git checkout feature/monan_regional-747-NF
```

Note: change this procedure in the final version with the official repository and tag.

## 2. Load the necessary modules and install python libraries

```
$ cd run
$ source load_monan_app_modules.sh
$ python3 -m ensurepip --user
$ python3 -m pip install --user netCDF4
$ python3 -m pip install --user numpy
$ python3 -m pip install --user cartopy
```

## 3. Copy of fixed data, tables, and scripts

Still inside the 'run' folder.

```
$ ./copy_data.bash
```

## 3. Compile Preprocessing Tools

```
$ cd ../pre/sources/MPAS-Tools/grid_rotate/
$ make
/opt/ohpc/pub/mpi/openmpi4-gnu9/4.1.1/bin/mpif90 grid_rotate.f90 -o ../../../exec/grid_rotate -O3 -I/mnt/beegfs/monan/libs_openmpi/netcdf/include -I/mnt/beegfs/monan/libs_openmpi/netcdf/include -L/mnt/beegfs/monan/libs_openmpi/netcdf/lib -L/mnt/beegfs/monan/libs_openmpi/netcdf/lib -lnetcdff -L/mnt/beegfs/monan/libs_openmpi/hdf5/lib -L/mnt/beegfs/monan/libs_openmpi/zlib/lib -L/mnt/beegfs/monan/libs_openmpi/netcdf/lib -lnetcdf -ldl -lm -lnetcdf -lhdf5_hl -lhdf5 -lz -Wl,-rpath,/mnt/beegfs/monan/libs_openmpi/netcdf/lib -Wl,-rpath,/mnt/beegfs/monan/libs_openmpi/hdf5/lib -Wl,-rpath,/mnt/beegfs/monan/libs_openmpi/zlib/lib -Wl,-rpath,/mnt/beegfs/monan/libs_openmpi/netcdf/lib  -Wl,-rpath,/mnt/beegfs/monan/libs_openmpi/netcdf/lib 
```
To confirm executable:
```
$ ls -l ../../../../pre/exec
```

## 4. Compile MONAN-Model

```
$ cd ../../../../model/sources
$ git clone https://github.com/monanadmin/MONAN-Model.git
$ mv MONAN-Model MONAN-Model_v1.4.2-rc_egeon.gnu940
$ cd MONAN-Model_v1.4.2-rc_egeon.gnu940
$ git checkout 1.4.2-rc
$ cp ../make.sh .
$ ./make.sh
```

To confirm the executables:
```
$ ls -l ../../../pre/exec/MONAN-Model_v1.4.2-rc_egeon.gnu940/exec/
$ ls -l ../../exec/MONAN-Model_v1.4.2-rc_egeon.gnu940/exec/
```

## 5. Compile Post-processing convert_mpas

```
$ cd ../../../pos/sources/
$ git clone https://github.com/monanadmin/convert_mpas.git
$ mv convert_mpas convert_mpas_v1.2.0_egeon.gnu940
$ cd convert_mpas_v1.2.0_egeon.gnu940
$ git checkout 1.2.0
$ cp ../make.sh .
$ ./make.sh
```
To confirm the executable:
```
$ ls -l ../../../pos/exec/convert_mpas_v1.2.0_egeon.gnu940/exec
```

## 6. Running

Mesh options with .grid.nc available for execution:

```
835586 variable_resolution = 060_003km
535554 variable_resolution = 060_015km
163842 variable_resolution = 092_025km
65536002 quasi_uniform = 003_km
2621442 quasi_uniform = 015_km
1024002 quasi_uniform = 024_km
163842 quasi_uniform = 060_km
40962 quasi_uniform = 120_km
```

Dates of available GFS files for initial condition:

```
2024042700
```

### 6.1. Pre-processing

```
$ cd ../../../run
$ ./runPre_oper.bash GFS 163842 2024042700 2024042800 regional Sudeste variable_resolution
```

### 6.2. Model

```
$ ./runModel_oper.bash GFS 163842 2024042700 2024042800 regional Sudeste variable_resolution
```

### 6.3. Post-processing

```
./runPost_oper.bash GFS 163842 2024042700 2024042800 regional Sudeste variable_resolution pnt
```

## 7. Visualization

```
$ ncview ../2024042700/pos/runs/GFS/postprd/MONAN_DIAG_R_POS_GFS_2024042700_2024042719.mm.x4.163842L55.nc
```

