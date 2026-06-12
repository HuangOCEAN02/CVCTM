#!/bin/bash
rm GI* *.mod *.o
ifort -r8 -convert big_endian chpar.f90
ifort -r8 -convert big_endian -o forcing_region_JRA55.o forcing_region_JRA55.f90
./forcing_region_JRA55.o -Wl,-T
rm *.o *.mod
