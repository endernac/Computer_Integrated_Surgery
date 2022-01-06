import numpy as np
import scipy.linalg as la

def get_centroid(points):
    # get the centroid of a point cloud
    return np.mean(points, 1, keepdims=True)

def get_H(p, tran_p):
    # get the H matrix as described in Arun et. al
    p_1 = p - get_centroid(p)
    tran_p_1 = tran_p - get_centroid(tran_p)
    H = p_1 @ tran_p_1.T
    return H

def get_R_hat(p, tran_p):
    # Calculate the rotation matrix from two point clouds as described in
    # Arun et al. First get the H matrix and perform SVD. Then calculate 
    # VU^T. If the resulting matrix is a reflection instead of a rotation,
    # negate the last column of V and redo the matrix multiplication.
    H = get_H(p, tran_p)
    U, S, VT = la.svd(H)
    R_hat = (U @ VT).T
    
    # correction if resulting matrix is a reflection
    if np.linalg.det(R_hat) < 0:
        VT[2] = -VT[2]
        R_hat = (U @ VT).T
    
    return R_hat

def get_T_hat(p, tran_p):
    # calculate the translational distance in centroids
    p_c = get_centroid(p)
    tran_p_c = get_centroid(tran_p)
    T_hat = tran_p_c - p_c
    return T_hat

def get_Registration(p, tran_p):
    # Find the rotational and translational adjustments and concatenate into 
    # homogenous transformation matrix F
    R_hat = get_R_hat(p, tran_p)
    T_hat = get_T_hat(p, tran_p)
    
    F = np.concatenate((R_hat, T_hat), 1)
    F = np.concatenate((F, np.array([[0,0,0,1]])))
    
    return F
