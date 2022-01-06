import numpy as np
import sys
from preprocess import calreading_data, calbody_data, empivot_data, optpivot_data
from registration import get_centroid, get_Registration
from pointer import piv_cal


# The data paths
name = sys.argv[1]
calreading_path = "./data/" + name + "-calreadings.txt"
calbody_path = "./data/" + name + "-calbody.txt"
empivot_path = "./data/" + name + "-empivot.txt"
optpivot_path = "./data/" + name + "-optpivot.txt"
output_path = "./output/" + name + "-output-1.txt"

# Question 4

# get the relevant data
D, A, C = calreading_data(calreading_path)
d, a, c = calbody_data(calbody_path)

# center the calibration coordinate points and convert c to homgenous coords
a_c = a.T - get_centroid(a.T)
c_c = c.T - get_centroid(c.T)
c_homo = np.concatenate((c_c, np.ones((1, c_c.shape[1]))))
C_expect = []

for i in range(D.shape[0]):
    # part 1 - find F_D
    F_D = get_Registration(d.T, D[i].T)
    
    # part 2 - find F_A
    F_A = get_Registration(a_c, A[i].T)
    
    # part 3 - calculate C_i expected
    C_hat = np.linalg.inv(F_D) @ F_A @ c_homo

    C_expect.append(C_hat[:3].T)

# Expected C_i coordinates for each Frame
C_expect = np.array(C_expect)

# Reshape for easier printing
N_frames, N_C, _ = C_expect.shape
C_expect = np.reshape(C_expect, (N_frames * N_C, 3))
C_expect = np.round(C_expect, 2)



# Question 5

# part 1 - get the centroid and create calibration coordinates
G = empivot_data(empivot_path)
G_0 = get_centroid(G[0].T)
g = G[0].T - G_0

# part 2 - calculate frame transformations
R_n = []
p_n = []

for k in range(G.shape[0]):
    # Get the frame transformation
    F_k = get_Registration(g, G[k].T)

    # extract rotation and translation matrices from F_k
    R_n.append(F_k[:3, :3])
    p_n.append(F_k[:3, 3])

# part 3 - calculate pivot calibration
R_n = np.array(R_n)
p_n = np.array(p_n)

b_tip, b_post_1 = piv_cal(R_n, p_n)
b_post_1 = np.round(b_post_1, 2)






# HW number 6

# part 1 - convert Optical tracker coordinates to EM tracker coordinates
# use same method used in prob 4
D, H = optpivot_data(optpivot_path)
d, a, c = calbody_data(calbody_path)

# Get centoid and create calibration coordinates
H_0 = get_centroid(H[0].T)
h = H[0].T - H_0
h_homo = np.concatenate((h, np.ones((1, h.shape[1]))))

H_EM = H.copy()

for i in range(D.shape[0]):
    #Use method from prob 4 to calculate H expected
    F_D = get_Registration(d.T, D[i].T)
    F_H = get_Registration(h, H[i].T)
    H_EM_hat = np.linalg.inv(F_D) @ F_H @ h_homo

    H_EM[i] = H_EM_hat[:3].T


# part 2 - calculate frame transformations in EM coordinates - reuse prob 5 code
R_n = []
p_n = []

for k in range(H_EM.shape[0]):
    F_k = get_Registration(h, H_EM[k].T)

    R_n.append(F_k[:3, :3])
    p_n.append(F_k[:3, 3])

# part 3 - calculate pivot calibration
R_n = np.array(R_n)
p_n = np.array(p_n)

b_tip, b_post_2 = piv_cal(R_n, p_n)
b_post_2 = np.round(b_post_2, 2)



# write to file
f = open(output_path, "w")

header = str(N_C) + ", " + str(N_frames) + ", " + name + "-output-1.txt" + "\n"

b_post_em = str(b_post_1[0]) + ", " + str(b_post_1[1]) + ", " + str(b_post_1[2]) + "\n"
b_post_opt = str(b_post_2[0]) + ", " + str(b_post_2[1]) + ", " + str(b_post_2[2]) + "\n"

lines = [header, b_post_em, b_post_opt]


for c in C_expect:
    datum = str(c[0]) + ", " + str(c[1]) + ", " + str(c[2]) + "\n"
    lines.append(datum)


f.writelines(lines)
