#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 13 11:44:42 2024

@author: josephhuang
"""

import sys
sys.path.append('../Model_info')
import os
import Stdinput as orctm
import netCDF4 as nc
import numpy as np
import datetime
import scipy.interpolate
#import pandas as pd
from scipy.ndimage import uniform_filter1d
# CVCM module
OBC = orctm.Orctm_cvcm('ORCTM_cvcm','TST-boundary for Temperature')
# %% time of OBC
year_start = year_end = 2011 
month_start = 1
month_end = 12

S_time = datetime.datetime(year_start,month_start,1,0,0,0)
E_time = datetime.datetime(year_end,month_end,31,23,0,0)

Inv_date = datetime.timedelta(hours=24)
SDtime = np.arange(S_time,E_time,Inv_date) # datetime64 属于numpy里面的时间类

# 2011 Up
#Begin_time = datetime.datetime(2011,1,1,0,0,0)
#Stop_time  = datetime.datetime(2011,6,30,0,0,0)
# 2011 Down
Begin_time = datetime.datetime(2011,7,1,0,0,0)
Stop_time  = datetime.datetime(2011,12,31,0,0,0)

t_s = np.where(SDtime == np.datetime64(Begin_time)) #返回的为tuple
t_e = np.where(SDtime == np.datetime64(Stop_time))

t_s = int(t_s[0])
t_e = int(t_e[0])

time_index =  np.datetime_as_string(SDtime[t_s:t_e+1],unit='h')
TE = int(t_e - t_s + 1)
# %% CMEMS file
locStrList=['West','East','North','South']
#locStrList=['South']
filestr = './2011/'
filename = '/CMEMS-For-CVCM_OBC_file_'
obc_doc = open('OBC_subtide_t.txt','w+',encoding='utf-8')
for obcid in locStrList:
    print(obcid,' Boundary Start')
    obc_doc.write(obcid+'\n')
    Grid_obc_info = np.load('obcp_'+obcid.lower()[0]+'.npz')
    data_dict = {key: Grid_obc_info[key] for key in Grid_obc_info}
    lat = data_dict['lat']
    lon = data_dict['lon']
    #dep = data_dict['dep']
    Zzp = data_dict['Zzp']
    # make sure the size of boundary matrix : 
    lat = lat[:, np.newaxis]
    lon = lon[:, np.newaxis]
    if obcid == 'East' or  obcid ==  'West':
        lat = lat.T
        lon = lon.T
    le = np.size(Zzp,axis=0)
    ke = np.size(Zzp,axis=1)
    mask = np.zeros_like(Zzp) + 1
    mask[Zzp==0]=0
    mask = mask.astype(int)
    if np.sum(mask[:,0]) != 0:
        obct_fid = open(filestr+'OB_tracer/OB_'+obcid+'_T.bin', 'wb')
        #print(filestr+obcid+filename[:]+obcid[0].lower()[0]+'.nc')
        obc_file = nc.Dataset(filestr+obcid+filename[:]+obcid[0].lower()[0]+'.nc',
                              mode='r',format='netCDF4')
        # 陆地点为masked，不为nan
        #print(obc_file.variables)
        latitude = obc_file.variables['latitude'][:]
        longitude = obc_file.variables['longitude'][:]
        longitude_grid,latitude_grid = np.meshgrid(longitude,latitude)
        
        
        DEP = obc_file.variables['depth'][:]
        to = obc_file.variables['thetao'][:,:,:,:]
        to = to.filled(fill_value = np.nan)
        
        nc.Dataset.close(obc_file)
        #  a 2-day smooth filter 
        keo = np.size(to,axis=1)
        obc_keo_to = np.zeros((le,keo))
        obc_to = np.zeros((le,ke))
        # 
        Lat_grid = OBC.rearrange_grid_to_orctm(latitude_grid)
        Lon_grid = OBC.rearrange_grid_to_orctm(longitude_grid)
        # select the time range
        to_range = to[t_s:t_e+1,:,:,:]
        # for smoothly restarting
        to_range[0,:,:,:] = to[t_s-1,:,:,:]
        for t in range(0,TE):
            obc_doc.write(time_index[t]+' No.'+str(t)+' day\n')
            for k in range(keo):
                to_grid  = OBC.rearrange_grid_to_orctm(to_range[t,k,:,:])
                land = np.zeros_like(to_grid)
                land[np.isnan(to_grid)]=1 # land 1 Sea: 0 !!!!
                if np.sum(land) != np.size(land):
                    obc_keo_to[:,k] = OBC.Grid_bilinear_interpolation( \
                    to_grid,land,Lat_grid,Lon_grid,lat,lon,landvalue=np.nanmean(to_grid)).flatten()
            #二维插值得到的没有nan
            obc_keo_to[obc_keo_to==0]=np.nan
            obc_to = OBC.vertical_interp(obc_keo_to,DEP,Zzp,mask)
            obc_to[mask==0] = np.nan
            # check obc
            # minimum
            obc_to = np.where(obc_to <= np.nanmin(to_range[t,:,:,:]),np.nanmin(to_range[t,:,:,:]),obc_to)
            # maximum
            obc_to = np.where(obc_to >= np.nanmax(to_range[t,:,:,:]),np.nanmax(to_range[t,:,:,:]),obc_to)  
            obc_to[np.isnan(obc_to)==True]=0
            for k in range(ke):
                obc_to[:,k].astype('>f8').tofile(obct_fid) 
        obc_doc.write(obcid+' End\n')
        obct_fid.close()
    else:
        obc_doc.write('No Open Boundary for '+obcid+'\n')
        obc_doc.write(obcid+' End\n')
        print('No Open Boundary for '+obcid)
    print(obcid,' Boundary End')
obc_doc.close()