import pandas as pd
import numpy as np

def calbody_data(filepath):
    '''
        Takes a filepath

        Returns 3 arrays
            d - the optical tracker points on the EM tracker
            a - the optical tracker points on the calibration body
            c - the EM tracker points on the calibration body
    '''
    data = pd.read_csv(filepath, header=None,names=["x", "y", "z", np.nan])
    N_D = int(data["x"][0])
    N_A = int(data["y"][0])
    N_C = int(data["z"][0])

    d = np.array(data[["x", "y", "z"]][1:1 + N_D])
    a = np.array(data[["x", "y", "z"]][1 + N_D : 1 + N_D + N_A])
    c = np.array(data[["x", "y", "z"]][1 + N_D + N_A :])
    return d, a, c


def calreading_data(filepath):
    '''
        Takes a filepath

        Returns 3 arrays:
            first array consists of of N_frames frames, each frame containing N_D measurements
            second array consists of of N_frames frames, each frame containing N_A measurements
            third array consists of of N_frames frames, each frame containing N_C measurements
    '''
    size = pd.read_csv(filepath, header=None,names=["D", "A", "C", "Frame", np.nan], nrows = 1)
    N_D = int(size["D"][0])
    N_A = int(size["A"][0])
    N_C = int(size["C"][0])
    N_Frames = int(size["Frame"][0])

    data = pd.read_csv(filepath, header=None,names=["x", "y", "z"], skiprows = [0])
    data = np.array(data[["x", "y", "z"]])
    by_frame = np.reshape(data, (N_Frames, N_D + N_A + N_C, 3))

    D = by_frame[:, :N_D]
    A = by_frame[:, N_D:N_D+N_A]
    C = by_frame[:, N_D+N_A:]

    return D, A, C


def empivot_data(filepath):
    '''
        Takes a filepath
        
        Returns an array of N_frames frames, each fram containing N_G measurements
    '''
    size = pd.read_csv(filepath, header=None,names=["G", "Frame", np.nan], nrows = 1)
    N_G = int(size["G"][0])
    N_Frames = int(size["Frame"][0])
    
    data = pd.read_csv(filepath, header=None,names=["x", "y", "z"], skiprows = [0])
    data = np.array(data[["x", "y", "z"]])
    G = np.reshape(data, (N_Frames, N_G, 3))
    
    return G


def optpivot_data(filepath):
    '''
        Takes a filepath
        
        Returns 2 arrays:
            first array consists of of N_frames frames, each frame containing N_D measurements
            second array consists of of N_frames frames, each frame containing N_H measurements
    '''
    size = pd.read_csv(filepath, header=None,names=["D", "H", "Frame", np.nan], nrows = 1)
    N_D = int(size["D"][0])
    N_H = int(size["H"][0])
    N_Frames = int(size["Frame"][0])
    
    data = pd.read_csv(filepath, header=None,names=["x", "y", "z"], skiprows = [0])
    data = np.array(data[["x", "y", "z"]])
    by_frame = np.reshape(data, (N_Frames, N_D + N_H, 3))
    
    D = by_frame[:, :N_D]
    H = by_frame[:, N_D:]

    return D, H

def emfiducials_data(filepath):
    return empivot_data(filepath)


def emnav_data(filepath):
    return empivot_data(filepath)


def ctfiducials_data(filepath):
    return pd.read_csv(filepath, header=None, skiprows=[0]).to_numpy()
