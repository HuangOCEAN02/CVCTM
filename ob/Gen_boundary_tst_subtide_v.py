#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov 16 13:57:11 2024

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
OBC = orctm.Orctm_cvcm('ORCTM_cvcm','TST-boundary for merdional velocity')
# %% time of OBC
year_start = 2011
year_end = 2011
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
obc_doc = open('OBC_subtide_v.txt','w+',encoding='utf-8')
# %%
for obcid in locStrList:
    print(obcid,' Boundary')
    obc_doc.write(obcid+'\n')
    Grid_obc_info = np.load('obcv_'+obcid.lower()[0]+'.npz')
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
    #   West/East: 1 × le 
    # North/South: le × 1
    le = np.size(Zzp,axis=0)
    ke = np.size(Zzp,axis=1)
    # boundary mask
    mask = np.zeros_like(Zzp) + 1
    mask[Zzp==0]=0
    mask = mask.astype(int)
    if np.sum(mask[:,0]) != 0:
        obcv_fid = open(filestr+'OB_subtide/OB_'+obcid+'_V.bin', 'wb')
        #print(filestr+obcid+filename[:]+obcid[0].lower()[0]+'.nc')
        obc_file = nc.Dataset(filestr+obcid+filename[:]+obcid[0].lower()[0]+'.nc',
                              mode='r',format='netCDF4')
        # 陆地点为masked，不为nan
        # print(obc_file.variables)
        latitude = obc_file.variables['latitude'][:]
        longitude = obc_file.variables['longitude'][:]
        longitude_grid,latitude_grid = np.meshgrid(longitude,latitude)

        DEP = obc_file.variables['depth'][:]
        vo = obc_file.variables['vo'][:,:,:,:]
        vo = vo.filled(fill_value = np.nan)

        nc.Dataset.close(obc_file)
        #  a 2-day smooth filter 
        keo = np.size(vo,axis=1)
        obc_keo_vo = np.zeros((le,keo))
        obc_vo = np.zeros((le,ke))
        # 
        Lat_grid = OBC.rearrange_grid_to_orctm(latitude_grid)
        Lon_grid = OBC.rearrange_grid_to_orctm(longitude_grid)
        #  a 2-day smooth filter 
        vo_filter = np.zeros_like(vo)
        for k in range(keo):
            vo_filter[:,k,:,:] = OBC.tst_smooth2d(vo[:,k,:,:],2)

        # select the time range
        vo_filter_range = vo_filter[t_s:t_e+1,:,:,:]
        # for smoothly restarting
        vo_filter_range[0,:,:,:] = vo_filter[t_s-1,:,:,:]
        for t in range(0,TE):
            obc_doc.write(time_index[t]+' No.'+str(t)+' day\n')
            for k in range(keo):
                vo_grid  = OBC.rearrange_grid_to_orctm(vo_filter_range[t,k,:,:])
                land = np.zeros_like(vo_grid)
                land[np.isnan(vo_grid)]=1 # land 1 Sea: 0 !!!!
                if np.sum(land) != np.size(land):
                    obc_keo_vo[:,k] = OBC.Grid_bilinear_interpolation( \
                    vo_grid,land,Lat_grid,Lon_grid,lat,lon,landvalue=0).flatten()
            #二维插值得到的没有nan
            obc_keo_vo[obc_keo_vo==0]=np.nan
            obc_vo = OBC.vertical_interp(obc_keo_vo,DEP,Zzp,mask)
            obc_vo[mask==0] = np.nan # masked
            # check obc
            # minimum
            obc_vo = np.where(obc_vo <= np.nanmin(vo_filter_range[t,:,:,:]),np.nanmin(vo_filter[t,:,:,:]),obc_vo)
            # maximum
            obc_vo = np.where(obc_vo >= np.nanmax(vo_filter_range[t,:,:,:]),np.nanmax(vo_filter[t,:,:,:]),obc_vo)
            obc_vo[np.isnan(obc_vo)==True]=0
            for k in range(ke):
                obc_vo[:,k].astype('>f8').tofile(obcv_fid) 
        obc_doc.write(obcid+' End\n')
        obcv_fid.close()
    else:
        obc_doc.write('No Open Boundary for '+obcid+'\n')
        obc_doc.write(obcid+' End\n')
        print('No Open Boundary for '+obcid)
    print(obcid,' Boundary End')
obc_doc.close()








