import numpy as np
import sys
from preprocess import calreading_data, calbody_data, empivot_data, optpivot_data, emfiducials_data, ctfiducials_data, emnav_data
from registration import get_centroid, get_Registration
from pointer import piv_cal
from distortion import getcoeff, undist

# The data paths
name = sys.argv[1]
calreading_path = "./data/" + name + "-calreadings.txt"
calbody_path = "./data/" + name + "-calbody.txt"
empivot_path = "./data/" + name + "-empivot.txt"
optpivot_path = "./data/" + name + "-optpivot.txt"
output_path = "./data/" + name + "-output-1.txt"
emfiducials_path = "./data/" + name + "-em-fiducialss.txt"
ctfiducials_path = "./data/" + name + "-ct-fiducials.txt"
emnav_path = "./data/" + name + "-EM-nav.txt"
output_path = "./output/" + name + "-output2.txt"

# Question 1
# get data
D, A, C = calreading_data("./data/pa2-debug-d-calreadings.txt")
d, a, c = calbody_data("./data/pa2-debug-d-calbody.txt")

# get centroids
a_c = a.T - get_centroid(a.T)
c_c = c.T - get_centroid(c.T)

# convert to homogeneous coordinates
c_homo = np.concatenate((c_c, np.ones((1, c_c.shape[1]))))

# array to store C^expected
C_expect = []

# get frame transformations
for i in range(D.shape[0]):
    F_D = get_Registration(d.T, D[i].T)
    F_A = get_Registration(a_c, A[i].T)
    C_hat = np.linalg.inv(F_D) @ F_A @ c_homo
    C_expect.append(C_hat[:3].T)

# store then reshape vector arrays
C_expect = np.array(C_expect)
N_frames, N_C, _ = C_expect.shape
C_expect = np.reshape(C_expect, (N_frames * N_C, 3))
C_obs = np.reshape(C, (N_frames * N_C, 3))

# Question 2
# normalize C's
minc = np.amin(C_obs, 0)
lenc = np.amax(C_obs, 0) - np.amin(C_obs, 0)
C_obs = (C_obs - minc) / lenc
C_expect = (C_expect - minc) / lenc

# get correction for distortion
coeff = getcoeff(C_obs, C_expect, 20)
C_expect = (C_expect + undist(coeff, C_expect)) * lenc + minc

# Question 3: get EM fiducials data then undistort
G = empivot_data(empivot_path)
N_frames, N_G = G.shape[:2]
G = np.reshape(G, (-1, 3))
G = G + undist(coeff, (G-minc) / lenc) * lenc
G = np.reshape(G, (N_frames, N_G, 3))

G_0 = get_centroid(G[0].T)
g = G[0].T - G_0

R_n = []
p_n = []

for k in range(G.shape[0]):
    # Get the frame transformation
    F_k = get_Registration(g, G[k].T)

    # extract rotation and translation matrices from F_k
    R_n.append(F_k[:3, :3])
    p_n.append(F_k[:3, 3])

# calculate pivot calibration
R_n = np.array(R_n)
p_n = np.array(p_n)

b_tip, b_post_1 = piv_cal(R_n, p_n)

# Question 4
# get EM fiducial data then normalize
G_fid = emfiducials_data(emfiducials_path)
N_frames, N_Gfid = G_fid.shape[:2]
G_fid = np.reshape(G_fid, (-1, 3))
G_fid = G_fid + undist(coeff, (G_fid - minc) / lenc) * lenc
G_fid = np.reshape(G_fid, (N_frames, N_Gfid, 3))
p_tip = []

# compute b_j
for k in range(G_fid.shape[0]):
    # Get the frame transformation
    F_k = get_Registration(g, G_fid[k].T)

    # find tip with respect to EM baes
    #tip = np.array([0,0,-np.linalg.norm(b_tip), 1])
    
    p = F_k @ np.append(b_tip, 1)
    p_tip.append(p[:3])

p_tip = np.array(p_tip)

# question 5
# get CT fiducials
b_i = ctfiducials_data(ctfiducials_path)

# calculate registration frame
F_reg = get_Registration(b_i.T, p_tip.T)

# Question 6
# get navigation data then normalize
G_nav = emnav_data(emnav_path)
N_frames, N_G = G_nav.shape[:2]
G_nav = np.reshape(G_nav, (-1, 3))
G_nav = G_nav + undist(coeff, (G_nav - minc) / lenc) * lenc
G_nav = np.reshape(G_nav, (N_frames, N_G, 3))
f_nav = []

# calculate b_j
for k in range(G_nav.shape[0]):
    # Get the frame transformation
    F_k = get_Registration(g, G_nav[k].T)

    # find tip with respect to EM base
    #tip = np.array([0,0,-np.linalg.norm(b_tip), 1])
    p = F_k @ np.append(b_tip, 1)
    f_nav.append(p[:3])

f_nav = np.array(f_nav)

# convert to homogeneous coordinates
f_nav_homo = np.concatenate((f_nav.T, np.ones((1, f_nav.shape[0])))).T

# calculate v
v = []
for k in range(f_nav_homo.shape[0]):
    v.append(np.round(np.linalg.inv(F_reg) @ f_nav_homo[k], 2))

v = np.array(v)[:, :3]
# write to file
f = open(output_path, "w+")
header = str(v.shape[0]) + ", " + name + "-output2.txt\n"
lines = [header]

for i in v:
    toadd = str(i[0]) + ", " + str(i[1]) + ", " + str(i[2]) + "\n"
    lines.append(toadd)

f.writelines(lines)
f.close()
