#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 10 10:43:46 2024

@author: josephhuang
"""
import sys
sys.path.append('../')
import os
import Model_info.Stdinput as orctm
import netCDF4 as nc
import numpy as np
from datetime import datetime
# %% Grid
CVCM = orctm.Orctm_cvcm('ORCTM_cvcm','3D Circulation simulation')
deuto_grid = CVCM.model_info_u('deuto_grid')
#latu_grid = CVCM.model_info_u('latu_grid')
#lonu_grid = CVCM.model_info_u('lonu_grid')
dduo_grid = CVCM.model_info_u('dduo_grid')
weto_u =  CVCM.model_info_u('weto_u')

zzout_u = np.zeros_like(weto_u)
tiefe =  np.zeros_like(deuto_grid)
sumtiefe = np.zeros_like(deuto_grid)
for k in range(0,CVCM.ke):
    tiefe = dduo_grid[:,:,k]
    zzout_u[:,:,k] = sumtiefe + tiefe/2
    sumtiefe = sumtiefe + tiefe
    #zzout_w[i,j,k+1] = sumtiefe
zzout_u[weto_u==0]=0


# TST - boundary
ncfile = '../Grid/anta_region.nc'
Ogrid = nc.Dataset(ncfile,mode='r',format='netCDF4')
print(Ogrid.variables)
ito = 2*CVCM.ie_g + 3
jto = 2*CVCM.je_g + 3

api =  3.1415926;
aradtogra = 180/api;

Gila = Ogrid.variables['var54'][:,:] # lon
Giph = Ogrid.variables['var55'][:,:] # lat
Gila = Gila*aradtogra
Giph = Giph*aradtogra

Gila = Gila.reshape(ito,jto,order='F')
Giph = Giph.reshape(ito,jto,order='F')

lonu_grid = Gila[1::2,0::2]
latu_grid = Giph[1::2,0::2]

# %% Boundary area
def match_obc(obcid):
    if obcid == 'w':
        print('West')
        lat_HCinput = latu_grid[0, 1:-1]
        lon_HCinput = lonu_grid[0, 1:-1]
        depto_HCinput = deuto_grid[0, :]
        zzout_HCinput = zzout_u[0, :, :]
    elif obcid == 'e':
        print('East')
        lat_HCinput = latu_grid[-1, 1:-1]
        lon_HCinput = lonu_grid[-1, 1:-1]
        depto_HCinput = deuto_grid[-1, :]
        zzout_HCinput = zzout_u[-1, :, :]
    elif obcid == 'n':
        print('North')
        lat_HCinput = latu_grid[:, 0]
        lon_HCinput = lonu_grid[:, 0]
        depto_HCinput = deuto_grid[:, 0]
        zzout_HCinput = zzout_u[:, 0, :]
    elif obcid == 's':
        print('South')
        lat_HCinput = latu_grid[:, -1]
        lon_HCinput = lonu_grid[:, -1]
        depto_HCinput = deuto_grid[:, -1]
        zzout_HCinput = zzout_u[:, -1, :]
    else:
        print('error')
    return lat_HCinput,lon_HCinput,depto_HCinput,zzout_HCinput

def check_matrix(mat):
    m,n = np.shape(mat)
    if n > m | n == 1 or 3:
        return mat.T
    else:
        return mat
# %% Extract
locStrList=['w','e','n','s']
for obcid in locStrList:
    lat,lon,dep,Zzp = match_obc(obcid)
    #lat = check_matrix(lat)
    #lon = check_matrix(lon)
    #dep = check_matrix(dep)
    #Zzp = check_matrix(Zzp)
    np.savez_compressed(
        'obcu_'+obcid+'.npz',lat=lat,lon=lon,dep=dep,Zzp=Zzp)
