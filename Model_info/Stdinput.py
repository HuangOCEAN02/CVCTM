#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  8 11:34:09 2024

@author: josephhuang
"""
import netCDF4 as nc
import numpy as np
import datetime
import os
import sys
import scipy.io
import scipy.interpolate
from scipy.ndimage import uniform_filter1d
class Orctm_cvcm:
    
    Model_dir ='/Users/josephhuang/Desktop/workingplace/风场试验/垂向网格/正压测试'
    #Grid_file = 'GRID_INFO.nc'
    # model grid
    ie_g = 817
    je_g = 619
    ke = 80
    # Vertical grid
    ZZOUT0 = np.zeros((ke,))
    ZZOUT = np.zeros_like(ZZOUT0)
    ZZOUT0 = np.array([5.31441, 5.69475, 6.10223, 6.53876, 7.00639, 7.50729, 8.0438, 8.61842,  \
      9.23377, 9.89270, 10.59818, 11.35342, 12.16179, 13.02687, 13.95244, 14.94251,   \
      16.00126, 17.13313, 18.34271, 19.63481, 21.01442, 22.48667, 24.05683, 25.73022, \
      27.51224, 29.4082, 31.42331, 33.56257, 35.83062, 38.23162, 40.76905, 43.44559,  \
      46.26282, 49.22106, 52.31908, 55.55387, 58.92039, 62.41133, 66.01695, 69.72493, \
      73.52033, 77.38561, 81.30085, 85.244, 89.19133, 93.11797, 96.99859, 100.80805,  \
      104.5222, 108.11858, 111.57706, 114.88035, 118.01442, 120.9687, 123.73612, 126.31304, \
      128.69899, 130.89634, 132.90991, 134.74654, 136.41459, 137.9236, 139.28383, 140.50595,\
      141.60072, 142.57882, 143.45057, 144.22587, 144.91407, 145.52391, 146.06348, 146.54024,\
      146.961, 147.33194, 147.65865, 147.94617, 148.19901, 148.42122, 148.61639, 148.78774],\
        dtype='float64')
    DEPTH_MAX=0
    for k in range(ke):
        tiefe = ZZOUT0[k]
        ZZOUT[k] = DEPTH_MAX + tiefe / 2.0
        DEPTH_MAX = DEPTH_MAX + tiefe
    # Model time
    Start_date = datetime.datetime(2011,1,1,0,0,0)
    End_date = datetime.datetime(2011,12,31,23,0,0)
    Inv_date = datetime.timedelta(hours=1)
    # Model time series
    SDtime = np.arange(Start_date,End_date,Inv_date) # datetime64 属于numpy里面的时间类
    time_index =  np.datetime_as_string(SDtime,unit='h')
    # Model time step
    dt = datetime.timedelta(seconds=120)
    Totalday = int((End_date - Start_date).days)  # total days
    Totalsecond = int((End_date - Start_date).total_seconds())  # total seconds
    te = int(Totalsecond/Inv_date.seconds) # all timesteps   
    run_perhour = int(1*3600/Inv_date.seconds)  # timesteps per one hour
    run_perday = int(24*3600/Inv_date.seconds)  # timesteps per one day
    # Ranked Number of model file
    LDTRUN =np.arange(0,te*Inv_date.seconds/dt.seconds,Inv_date.seconds/dt.seconds,
                     dtype=np.int64)
    isdiagnosis = False
    vars_code = [63,64,71,72,73,74,82,77,146,76]
    vars_name = ['USO','VSE','THO','SAO','UOO','VOE','ZOO','PNH','WO','PO']
    # DATA info.
    # Sponge layer
    siw = 10
    sie = 1
    sjn = sjs = 10
    ###### Model file time !!!!
    Start_date_file = datetime.datetime(2025,2,1,0,0,0)
    End_date_file = datetime.datetime(2025,3,31,23,0,0)
    LDTRUN_file = LDTRUN[31*24:]
    SDFiletime = np.arange(Start_date_file,End_date_file+Inv_date,Inv_date) # datetime64 属于numpy里面的时间类
    time_index =  np.datetime_as_string(SDFiletime,unit='h')
    # Model data read
    # USO
    '''
    uso_file = '/Volumes/Backup Plus/Cruise/BT/data/USO_Cruise/'
    uso_name = os.listdir(uso_file)
    uso_name = sorted(uso_name, key=lambda x : int(x.split('_')[-1].split('.')[0]))
    # VSE
    vse_file = '/Volumes/Backup Plus/Cruise/BT/data/VSE_Cruise/'
    vse_name = os.listdir(vse_file)
    vse_name = sorted(vse_name, key=lambda x : int(x.split('_')[-1].split('.')[0]))
    # ZOO
    zoo_file = '/Volumes/Backup Plus/Cruise/BT/data/ZOO_Cruise/'
    zoo_name = os.listdir(zoo_file)
    zoo_name = sorted(zoo_name, key=lambda x : int(x.split('_')[-1].split('.')[0]))
    '''
    def __init__(self,model,case):
        self.model = model
        self.case = case
        self.class_directory = os.path.dirname(os.path.abspath(__file__))
        #当前class目录
        print('-------ORCTM Assignment-----')
        print('-------CVCTM Circulation Model-----')
        print('-------Based on CVTM configuration-----')        
        print('       ie_g,je_g,ke')
        print('       End_date')
        print('       Start_date')
        print('       End_date')
        print('       Inv_date')
        print('       SDtime')
        print('       time_index')
        print('       dt')
        print('       Totalday')
        print('       Totalsecond')
        print('       LDTRUN')
        print('       isdiagnosis')
        print('       vars_code')
        print('       vars_name')
        print(' .     siw,sie,sjn,sjs (sponge layer)')
        print('-------ORCTM initialized-----')    
    # 读取diagnostic 模块配置
    def diagnosis(self):
        Diag_point = scipy.io.loadmat(Orctm_cvcm.Model_dir+'/diagnosis_info.mat')
        return Diag_point
    '''
    # 读取model x-axis
    def model_x_axis(self):
        Model_Grid = scipy.io.loadmat(Orctm_2D.Model_dir+'/Model_Grid.mat')
        xx = Model_Grid['xn']
        return xx
    '''
    def model_info_p(self,VAR):
        Grid_info = np.load(self.class_directory+'/Grid_info.npz')
        data_dict = {key: Grid_info[key] for key in Grid_info}
        data_var = data_dict[VAR]
        return data_var
    
    def model_info_u(self,VAR):
        Grid_info_u = np.load(self.class_directory+'/Grid_info_u.npz')
        data_dict = {key: Grid_info_u[key] for key in Grid_info_u}
        data_var = data_dict[VAR]
        return data_var  
    
    def model_info_v(self,VAR):
        Grid_info_v = np.load(self.class_directory+'/Grid_info_v.npz')
        data_dict = {key: Grid_info_v[key] for key in Grid_info_v}
        data_var = data_dict[VAR]
        return data_var    
    
    def model_info_w(self,VAR):
        Grid_info_w = np.load(self.class_directory+'/Grid_info_w.npz')
        data_dict = {key: Grid_info_w[key] for key in Grid_info_w}
        data_var = data_dict[VAR]
        return data_var  
    
    def model_resolution(self,VAR):
        Grid_resolution = np.load(self.class_directory+'/Grid_resolution.npz')
        data_dict = {key: Grid_resolution[key] for key in Grid_resolution}
        data_var = data_dict[VAR]
        return data_var
    
    def model_diagnosis(self):
        Diag_info = np.load(self.class_directory+'/Diag_info.npz',allow_pickle=True)
        Diag_info_dict = Diag_info.item()
        return Diag_info_dict
    
    @staticmethod
    def check_file_number(Stime,Etime):
        """
            返回选择时间段内的的文件number
            retrun the file numbers based on the input start&end dates
        """
        t_s = np.where(Orctm_cvcm.SDtime == np.datetime64(Stime)) #返回的为tuple
        t_e = np.where(Orctm_cvcm.SDtime == np.datetime64(Etime))
        print('From: ',Orctm_cvcm.time_index[t_s])
        print('to: ',Orctm_cvcm.time_index[t_e])
        Snum = Orctm_cvcm.LDTRUN[t_s]
        Enum = Orctm_cvcm.LDTRUN[t_e]
        return Snum,Enum
    
    #function for coverting Matlab's datenum into datetime
    #from https://gist.github.com/victorkristof/b9d794fe1ed12e708b9d
    @staticmethod
    def datenum_to_datetime(datenum):
        """
        Convert Matlab datenum into Python datetime.
        :param datenum: Date in datenum format
        :return:        Datetime object corresponding to datenum.
        """
        days = datenum % 1
        return datetime.date.fromordinal(int(datenum)) \
           + datetime.timedelta(days=days) \
           - datetime.timedelta(days=366)
           
# datetime.fromordinal(int(matlab_datenum)) + timedelta(days=matlab_datenum%1) - timedelta(days = 366)
#function for converting date to year.fraction
#from https://stackoverflow.com/questions/6451655/how-to-convert-python-datetime-dates-to-decimal-float-years
    @staticmethod
    def year_fraction(date):
        start = datetime.date(date.year, 1, 1).toordinal()
        year_length = datetime.date(date.year+1, 1, 1).toordinal() - start
        return date.year + float(date.toordinal() - start) / year_length  
    
# remove the sponge layers
    @staticmethod
    def Exclude_sponge(spongew,spongee,spongen,sponges,Indata):
         k = np.ndim(Indata)
         if k == 2:
             # N
             if spongen != 1:
                clipped = np.delete (Indata, range(0,spongen), axis=1)
             # S
             if sponges != 1:
                clipped = np.delete (clipped, range(-1,-sponges-1,-1), axis=1)
             # W
             if spongew != 1:
                clipped = np.delete (clipped, range(0,spongew), axis=0)
             # E
             if spongee != 1:
                clipped = np.delete (clipped, range(-1,-spongee-1,-1), axis=0)
             elif k == 3:
                 # N
                 if spongen != 1:
                    clipped = np.delete (clipped, range(0,spongen), axis=1)
                 # S
                 if sponges != 1:
                    clipped = np.delete (clipped, range(-1,-sponges-1,-1), axis=1)
                 # W
                 if spongew != 1:
                    clipped = np.delete (clipped, range(0,spongew), axis=0)
                 # E
                 if spongee != 1:
                    clipped = np.delete (clipped, range(-1,-spongee-1,-1), axis=0)
    
         return clipped
    @staticmethod
    def rearrange_grid_to_orctm(data_matrix):
        '''
        data_matrix (x,y), CMEMS Glorys data grid to ORCTM model grid
        First transpose, and flip column
        '''
        data_matrix = data_matrix.T # lat
        data_matrix = data_matrix[:,::-1] 
        return data_matrix
    @staticmethod
    def tst_smooth2d(data,days):
        '''
        data (time,x,y), days: windows of average defalut: 2days
        low-pass filter
        '''
        data_smooth = uniform_filter1d(data,size=days, axis=0)
        return data_smooth
    @staticmethod
    def vertical_interp(var_profile,dep_profile,new_depth,new_mask):
        """
        Parameters
        ----------
        var_profile : size:(le,keo)
            DESCRIPTION.
        dep_profile : size:(keo)
            DESCRIPTION.
        new_depth : size:(le,ke)
            DESCRIPTION.
        new_mask : size:(le,ke)
        
        Returns
        -------
        y_interp : TYPE
            DESCRIPTION.
    
        """
        var_interp = np.zeros_like(new_depth)
        for i in range(np.size(new_depth,axis=0)):
            # No.1 check Nan or Missing loc
            if new_mask[i,0] !=0:
                yb = var_profile[i,~np.isnan(var_profile[i,:])]
                xb = dep_profile[~np.isnan(var_profile[i,:])]
                dsort = np.argsort(xb)
                Seabed = np.sum(new_mask[i,:])
                xn = new_depth[i,0:Seabed]
                # the left and right boundary default are set nearest
                var_interp[i,0:Seabed] = np.interp(xn,xb[dsort],yb[dsort])
            else:
                var_interp[i,:] = 0
        return var_interp
    @staticmethod
    def vertical_interp2d(var_profile,dep_profile,new_depth,new_mask):
        """
        Parameters
        ----------
        var_profile : size:(ie,je,keo)
            DESCRIPTION.
        dep_profile : size:(keo)
            DESCRIPTION.
        new_depth : size:(ie,je,ke)
            DESCRIPTION.
        new_mask : size:(ie,je,ke)
        
        Returns
        -------
        y_interp : TYPE
            DESCRIPTION.
        """
        var_interp = np.zeros_like(new_depth)
        for i in range(np.size(new_depth,axis=0)):
            for j in range(np.size(new_depth,axis=1)):
                # No.1 check Nan or Missing loc
                if new_mask[i,j,0] !=0:
                    yb = var_profile[i,j,~np.isnan(var_profile[i,j,:])]
                    xb = dep_profile[~np.isnan(var_profile[i,j,:])]
                    dsort = np.argsort(xb)
                    Seabed = np.sum(new_mask[i,j,:])
                    xn = new_depth[i,j,0:Seabed]
                    # the left and right boundary default are set nearest
                    var_interp[i,j,0:Seabed] = np.interp(xn,xb[dsort],yb[dsort])
                else:
                    var_interp[i,j,:] = 0
        return var_interp
    @staticmethod
    def smooth_land_sea_transition(soe, land, num_iterations=100, eps=1e-12):
        """
        Apply smoothing to a grid with land-sea boundaries.
        
        Parameters:
        - soe: 2D numpy array of shape (IFE, JFE) representing the data grid.
        - land: 2D numpy array of shape (IFE, JFE) where values <= 0.5 indicate sea, > 0.5 indicate land.
        - num_iterations: Number of smoothing iterations to apply.
        - eps: Small value used to distinguish between land and sea.
        
        Returns:
        - A smoothed 2D numpy array of the same shape as soe.
        """
        IFE, JFE = soe.shape
        # Sea points are set to 1, land points to eps
        HG = np.where(land <= 0.5, 1.0, eps)  
        HHX = np.copy(soe)  # Initialize HHX with the original data
        
        for _ in range(num_iterations):
            G = np.copy(HG) # mask of orginal data grid
            HX = np.copy(HHX)
            # Internal area
            for j in range(1, JFE - 1):
                for i in range(1, IFE - 1):
                    if land[i, j] >= 0.5: # into the land area !!!
                        # Calculate the smoothed value for HG
                        rsumg = (4 * G[i, j] + G[i-1, j] + G[i+1, j] + G[i, j-1] + G[i, j+1]) / 8
                        HG[i, j] = min(rsumg, 0.125)
                        # Update HHX at this grid point
                        HHX[i, j] = (
                        (4 * HX[i, j] * G[i, j] +
                         HX[i-1, j] * G[i-1, j] +
                         HX[i+1, j] * G[i+1, j] +
                         HX[i, j-1] * G[i, j-1] +
                         HX[i, j+1] * G[i, j+1]) / 8
                        ) / rsumg
            for j in range(1, JFE - 1):
                # Up boundary
                i = 0
                if land[i, j] >= 0.5:
                    # Calculate the smoothed value for HG
                    rsumg = (3 * G[i, j] + G[i+1, j] + G[i, j-1] + G[i, j+1]) / 6
                    HG[i, j] = min(rsumg, 1/6)
                    # Update HHX at this grid point
                    HHX[i, j] = (
                    (3 * HX[i, j] * G[i, j] +
                     HX[i+1, j] * G[i+1, j] +
                     HX[i, j-1] * G[i, j-1] +
                     HX[i, j+1] * G[i, j+1]) / 6
                    ) / rsumg
                # down boundary
                i = IFE-1
                if land[i, j] >= 0.5: # into the land area !!!
                     # Calculate the smoothed value for HG
                     rsumg = (3 * G[i, j] + G[i-1, j] + G[i, j-1] + G[i, j+1]) / 6
                     HG[i, j] = min(rsumg, 1/7)
                     # Update HHX at this grid point
                     HHX[i, j] = (
                        (3 * HX[i, j] * G[i, j] +
                         HX[i-1, j] * G[i-1, j] +
                         HX[i, j-1] * G[i, j-1] +
                         HX[i, j+1] * G[i, j+1]) / 6
                        ) / rsumg
            for i in range(1, IFE - 1):
                # Left boundary
                j = 0
                if land[i, j] >= 0.5: # into the land area !!!
                    # Calculate the smoothed value for HG
                    rsumg = (3 * G[i, j] + G[i-1, j] + G[i+1, j] + G[i, j+1]) / 6
                    HG[i, j] = min(rsumg, 1/6)
                    # Update HHX at this grid point
                    HHX[i, j] = (
                    (3 * HX[i, j] * G[i, j] +
                     HX[i-1, j] * G[i-1, j] +
                     HX[i+1, j] * G[i+1, j] +
                     HX[i, j+1] * G[i, j+1]) / 6
                        ) / rsumg
                # Left boundary
                j = JFE-1
                if land[i, j] >= 0.5: # into the land area !!!
                    # Calculate the smoothed value for HG
                    rsumg = (3 * G[i, j] + G[i-1, j] + G[i+1, j] + G[i, j-1]) / 6
                    HG[i, j] = min(rsumg, 1/6)
                    # Update HHX at this grid point
                    HHX[i, j] = (
                    (3 * HX[i, j] * G[i, j] +
                     HX[i-1, j] * G[i-1, j] +
                     HX[i+1, j] * G[i+1, j] +
                     HX[i, j-1] * G[i, j-1]) / 6
                    ) / rsumg     
            # Four conrners
            if land[0, 0] >= 0.5:
                rsumg = (2*G[0, 0] +  G[1,0] + G[0,1])/4
                HG[0, 0] = min(rsumg, 1/4)
                HHX[0,0]= (
                (2*HX[0,0]*G[0,0]+ 
                 HX[1,0] * G[1,0] +
                 HX[0,1] * G[0,1])/4.0
                ) / rsumg
            if land[0, -1] >= 0.5:
                rsumg = (2*G[0, -1] +  G[0,-2] + G[1,-1])/4
                HG[0, -1] = min(rsumg, 1/4)
                HHX[0,-1]= (
                (2*HX[0,-1]*G[0,-1]+ 
                 HX[0,-2] * G[0,-2] +
                 HX[1,-1] * G[1,-1])/4.0
                ) / rsumg
            if land[-1, 0] >= 0.5: 
                rsumg = (2*G[-1, 0] +  G[-2,0] + G[-1,1])/4
                HG[-1, 0] = min(rsumg, 1/4)
                HHX[-1, 0]= (
                (2*HX[-1, 0]*G[-1, 0]+ 
                 HX[-2,0] * G[-2,0] +
                 HX[-1,1] * G[-1,1])/4.0
                ) / rsumg
            if land[-1, -1] >= 0.5: 
                rsumg = (2*G[-1, -1] +  G[-2,-1] + G[-1,-2])/4
                HG[-1, -1] = min(rsumg, 1/4)
                HHX[-1, -1]= (
                (2*HX[-1, -1]*G[-1, -1]+ 
                 HX[-2,-1] * G[-2,-1] +
                 HX[-1,-2] * G[-1,-2])/4.0
                ) / rsumg
        nland = np.sum(HG <= 2.0 * eps)
        #print('iter: ',num_iterations,' Nland: ', nland)
        HHX = np.where( abs(HHX) < eps, 0,HHX)
        return HHX,HG

    @staticmethod
    def nearest_interpolation(soe,lato,lono,latp,lonp):
        """
            Nearest interpolation for single staion
        """
        # interpolator
        interpbot = scipy.interpolate.RegularGridInterpolator( 
            (lato,lono), soe, method='nearest',bounds_error=False, fill_value=None)
        soe_interp = interpbot( (latp,lonp) )
        return soe_interp

    @staticmethod
    def Grid_bilinear_interpolation(soe,land,lato_grid,lono_grid,latn_grid,lonn_grid,landvalue=0):
        # land 1 Sea: 0 !!!!
        # Fill NaNs in soe with landvalue
        soe = np.where(np.isnan(soe), landvalue, soe)
        son,g = Orctm_cvcm.smooth_land_sea_transition(soe, land, num_iterations=5, eps=1e-12)
        IE_1,JE_1 = lonn_grid.shape
        # Convert degrees to radians
        lono_grid = np.where(lono_grid<0,lono_grid+360, lono_grid)
        lonn_grid = np.where(lonn_grid<0,lonn_grid+360, lonn_grid)
        # Radians
        lato_grid = lato_grid /  180.0 / np.pi
        lono_grid = lono_grid /  180.0 / np.pi
        latn_grid = latn_grid /  180.0 / np.pi
        lonn_grid = lonn_grid /  180.0 / np.pi
        sreg = np.zeros_like(lonn_grid)
        for m in range(IE_1):
            for n in range(JE_1):
                # 这块有问题
                # jo = np.searchsorted(lato_grid[0,:], latn_grid[m, n]) - 1 # ascending strictly
                # il = np.searchsorted(lono_grid[:,0], lonn_grid[m, n]) - 1
                # New
                # lato_grid is descending, find the end of value larger than point of [m,n]
                # lono_grid is ascending, find the end of value smaller than point of [m,n]
                jo = np.where(lato_grid[0,:] >= latn_grid[m, n])[0][-1] # left[north]
                il = np.where(lono_grid[:,0] <= lonn_grid[m, n])[0][-1] # up[west]
                jlu, ilu = jo + 1, il
                #        N----------------S 
                # W        
                # | #[ilu,jlu-1]    #[ilu,jlu]
                # |
                # |           *[m,n]
                # |
                # | #[ilu+1,jlu-1]  #[ilu+1,jlu]
                # E                
                # ---------------------------------
                wwwwalpha = lato_grid[ilu, jlu] - latn_grid[m, n]
                wwwbeta = lono_grid[ilu, jlu] - lonn_grid[m, n]
                
                if wwwbeta >= np.pi:
                    wwwbeta = wwwbeta - 2*np.pi
                if wwwbeta <= -np.pi:
                    wwwbeta = wwwbeta + 2*np.pi
                # --- normalizing
                alpha = wwwwalpha / (lato_grid[ilu, jlu] - lato_grid[ilu, jlu-1])
                beta = wwwbeta / (lono_grid[ilu, jlu] - lono_grid[ilu+1, jlu])
                # --- interpolating
                sreg[m, n] = (
                        alpha * beta * son[ilu+1, jlu-1] * g[ilu+1, jlu-1] +
                        (1 - alpha) * (1 - beta) * son[ilu, jlu] * g[ilu, jlu] +
                        (1 - alpha) * beta * son[ilu+1, jlu] * g[ilu+1, jlu] +
                        alpha * (1 - beta) * son[ilu, jlu-1] * g[ilu, jlu-1]
                    )
                sreg[m, n] /= (
                        alpha * beta * g[ilu+1, jlu-1] +
                        (1 - alpha) * (1 - beta) * g[ilu, jlu] +
                        (1 - alpha) * beta * g[ilu+1, jlu] +
                        alpha * (1 - beta) * g[ilu, jlu-1]
                    )
        return sreg

    def Find_point_box(self,lono,lato,lonm,latm):
        jo = np.where(latm[0,:] >= lato)[0][-1] # left[north]
        il = np.where(lonm[:,0] <= lono)[0][-1] # up[west]
                #        N----------------S 
                # W        
                # | #[ilu,jlu-1]    #[ilu,jlu]
                # |
                # |           *[m,n]
                # |
                # | #[ilu+1,jlu-1]  #[ilu+1,jlu]
                # E                
                # ---------------------------------
        jlu, ilu = jo + 1, il

        print(f'Right Up: Longitude = {lonm[ilu, jlu]}, Latitude = {latm[ilu, jlu]}')
        print(f'Right Down: Longitude = {lonm[ilu+1, jlu]}, Latitude = {latm[ilu+1, jlu]}')
        print(f'Left Down: Longitude = {lonm[ilu+1, jlu-1]}, Latitude = {latm[ilu+1, jlu-1]}')
        print(f'Left Up: Longitude = {lonm[ilu, jlu-1]}, Latitude = {latm[ilu, jlu-1]}')
        
        BOX = dict()
        Points = ['RU','RD','LD','LU']
        Indexs = [(ilu, jlu),(ilu+1, jlu),(ilu+1, jlu-1),(ilu, jlu-1)]
        
        BOX = {P:I for P,I in zip(Points,Indexs)}
        return BOX
        
        

if __name__ == '__main__':



    # 输出当前工作目录
    current_directory = os.getcwd()
    print("当前工作目录:", current_directory)
    
    CVCM = Orctm_cvcm('ORCTM_cvcm','3D Circulation simulation')
  
    S_time = datetime.datetime(2025,2,1,0,0,0)
    E_time = datetime.datetime(2025,2,1,23,0,0)
    Snum,Enum = CVCM.check_file_number(S_time,E_time)
    
    # Model Grid
    IE_G = CVCM.ie_g*2+1
    JE_G = CVCM.je_g*2+1
    ke = CVCM.ke
    # !:: PETERSPY: ICODE (ABC)
    # !     A: 1-> lon/lat 2 -> water depth; 3 -> sea mask; 4 -> grid interval
    # !     B: 0 -> no direction; 1/2/3 -> X/Y/Z direction
    # !     C: 0/1/2 -> variable locates at P/U/V point
    # !
    
    # model grid data
    fgrid = nc.Dataset(CVCM.Model_dir+'/GRID_INFO.nc',mode='r',format='netCDF4')
    # print(fgrid.variables)
    
    # toppgraphy 
    depto_grid = fgrid.variables['var200'][:]
    depto_grid = depto_grid.reshape(CVCM.ie_g,CVCM.je_g,order='F')
    depto_grid[depto_grid == 0] = np.nan
    
    deuto_grid = fgrid.variables['var201'][:]
    deuto_grid = deuto_grid.reshape(CVCM.ie_g+1,CVCM.je_g,order='F')
    deuto_grid[deuto_grid == 0] = np.nan
    
    deute_grid = fgrid.variables['var202'][:]
    deute_grid = deute_grid.reshape(CVCM.ie_g,CVCM.je_g+1,order='F')
    deute_grid[deute_grid == 0] = np.nan
    
    # lon lat
    lonp_grid = fgrid.variables['var110'][:]
    lonp_grid = lonp_grid.reshape(CVCM.ie_g,CVCM.je_g,order='F')
    
    latp_grid = fgrid.variables['var120'][:]
    latp_grid = latp_grid.reshape(CVCM.ie_g,CVCM.je_g,order='F')
    
    Point_box = CVCM.Find_point_box(-25,15,lonp_grid,latp_grid)
    
    lonu_grid = fgrid.variables['var111'][:]
    lonu_grid = lonu_grid.reshape(CVCM.ie_g+1,CVCM.je_g,order='F')
    
    latu_grid = fgrid.variables['var121'][:]
    latu_grid = latu_grid.reshape(CVCM.ie_g+1,CVCM.je_g,order='F')
    
    
    lonv_grid = fgrid.variables['var112'][:]
    lonv_grid = lonv_grid.reshape(CVCM.ie_g,CVCM.je_g+1,order='F')
    
    latv_grid = fgrid.variables['var122'][:]
    latv_grid = latv_grid.reshape(CVCM.ie_g,CVCM.je_g+1,order='F')
    
    # mask
    weto_p = fgrid.variables['var300'][:,:]
    weto_p = weto_p.transpose(1,0)
    weto_p = weto_p.astype(np.float64)
    weto_p = weto_p.reshape(CVCM.ie_g,CVCM.je_g,ke,order='F')
    
    weto_u = fgrid.variables['var301'][:]
    weto_u = weto_u.transpose(1,0)
    weto_u = weto_u.astype(np.float64)
    weto_u = weto_u.reshape(CVCM.ie_g+1,CVCM.je_g,ke,order='F')
    
    weto_v = fgrid.variables['var302'][:]
    weto_v = weto_v.transpose(1,0)
    weto_v = weto_v.astype(np.float64)
    weto_v = weto_v.reshape(CVCM.ie_g,CVCM.je_g+1,ke,order='F')
    
    # veritcal layer
    ddpo_grid = fgrid.variables['var430'][:]
    ddpo_grid = ddpo_grid.transpose(1,0)
    ddpo_grid = ddpo_grid.astype(np.float64)
    ddpo_grid = ddpo_grid.reshape(CVCM.ie_g,CVCM.je_g,ke,order='F')
    
    dduo_grid = fgrid.variables['var431'][:]
    dduo_grid = dduo_grid.transpose(1,0)
    dduo_grid = dduo_grid.astype(np.float64)
    dduo_grid = dduo_grid.reshape(CVCM.ie_g+1,CVCM.je_g,ke,order='F')
    
    ddue_grid = fgrid.variables['var432'][:]
    ddue_grid = ddue_grid.transpose(1,0)
    ddue_grid = ddue_grid.astype(np.float64)
    ddue_grid = ddue_grid.reshape(CVCM.ie_g,CVCM.je_g+1,ke,order='F')
    
    
    # horzontal resolution
    dlxp = fgrid.variables['var410'][:]
    dlxp = dlxp.reshape(CVCM.ie_g,CVCM.je_g,order='F')
    
    dlxu = fgrid.variables['var411'][:]
    dlxu = dlxu.reshape(CVCM.ie_g+1,CVCM.je_g,order='F')
    
    dlxv = fgrid.variables['var412'][:]
    dlxv = dlxv.reshape(CVCM.ie_g,CVCM.je_g+1,order='F')
    
    dlyp = fgrid.variables['var420'][:]
    dlyp = dlyp.reshape(CVCM.ie_g,CVCM.je_g,order='F')
    
    dlyu = fgrid.variables['var421'][:]
    dlyu = dlyu.reshape(CVCM.ie_g+1,CVCM.je_g,order='F')
    
    dlyv = fgrid.variables['var422'][:]
    dlyv = dlyv.reshape(CVCM.ie_g,CVCM.je_g+1,order='F')
    
    # vertical index
    sum_layer = np.sum(weto_p,axis=-1) # 或者axis=2
    bottom_index = np.zeros((CVCM.ie_g,CVCM.je_g),dtype=np.float64)
    bottom_index = sum_layer
    bottom_index[sum_layer == 0] = 0
    bottom_index=bottom_index.astype(int)
    # Layer depth
    zzout   = np.zeros((CVCM.ie_g,CVCM.je_g,ke),dtype=np.float64);
    zzout_w = np.zeros((CVCM.ie_g,CVCM.je_g,ke+1),dtype=np.float64);
    
    #sumtiefe = np.float64(0)
    #tiefe = np.float64(0)
    
    for i in range(0,CVCM.ie_g):
        for j in range(0,CVCM.je_g):
            if bottom_index[i,j] != 0:
                tiefe = 0
                sumtiefe = 0
                for k in range(0,ke):
                    tiefe = ddpo_grid[i,j,k]
                    zzout[i,j,k] = sumtiefe + tiefe/2
                    sumtiefe = sumtiefe + tiefe
                    zzout_w[i,j,k+1] = sumtiefe
    
    zzout[weto_p==0]=0
    
    # savedata
    np.savez_compressed('Grid_info_w.npz',
                        zzout_w=zzout_w,bottom_index=bottom_index)
    np.savez_compressed('Grid_info.npz', 
                        ie_g=CVCM.ie_g,je_g=CVCM.je_g,ke=ke,
                        lonp_grid=lonp_grid,latp_grid=latp_grid,
                        zzout=zzout,weto_p=weto_p,
                        depto_grid=depto_grid,ddpo_grid=ddpo_grid)
    np.savez_compressed('Grid_info_u.npz', 
                        ie_g=CVCM.ie_g,je_g=CVCM.je_g,ke=ke,
                        lonu_grid=lonu_grid,latu_grid=latu_grid,
                        weto_u=weto_u,deuto_grid=deuto_grid,
                        dduo_grid=dduo_grid)
    np.savez_compressed('Grid_info_v.npz', 
                        ie_g=CVCM.ie_g,je_g=CVCM.je_g,ke=ke,
                        lonv_grid=lonv_grid,latv_grid=latv_grid,
                        weto_v=weto_v,deute_grid=deute_grid,
                        ddue_grid=ddue_grid)
    np.savez_compressed('Grid_resolution.npz', 
                        dlxp=dlxp,dlyp=dlyp,dlxu=dlxu,
                        dlyu=dlyu,dlxv=dlxv,dlyv=dlyv)
    # test load
    #test = np.load('Grid_info_v.npz')['arr8']
    
#%%
    # Diagnostic timeinfo
    diagnosis = CVCM.isdiagnosis
    if diagnosis:
        diagnosis_site = CVCM.diagnosis()
        ncdump_dia = datetime.timedelta(seconds=60)
        SDtime_dia =np.arange(CVCM.Start_date,CVCM.End_date,ncdump_dia) # datetime64 属于numpy里面的时间类
        time_index_dia =  np.datetime_as_string(SDtime_dia,unit='s')
        run_perhour = int(1*3600/ncdump_dia.seconds)  # timesteps per one hour
        run_perday = int(24*3600/ncdump_dia.seconds)  # timesteps per one day
        te_dia = int(CVCM.Totalsecond/ncdump_dia.seconds) # all timesteps
        np.savez_compressed('Diag_info.npz',diagnosis_site=diagnosis_site,
                            SDtime_dia=SDtime_dia,run_perhour=run_perhour,
                            run_perday=run_perday,
                            te_dia=te_dia,time_index_dia=time_index_dia)
        
        
        
        
       
        
