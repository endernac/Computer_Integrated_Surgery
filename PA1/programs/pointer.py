import numpy as np

def piv_cal(R_n, p_n):
    '''
        Parameters: R_1 ... R_n rotation matrices of pointer body (relative to reference frame)
                    p_1 ... p_n displacements of pointer body (relative to reference frame)

        Returns: b_tip - displacement of tip from the pointer
                 b_post - displacement of post from reference frame

        Performs a least square problem:

        [ R_1 | -I ]             [-p_1]
        | R_2 | -I |             [-p_2]
        |  .  |  . | [p_tip ] =  |  . |
        |  .  |  . | [p_post]    |  . |
        |  .  |  . |             |  . |
        [ R_n | -I ]             [-p_n]
    '''
    n = R_n.shape[0]

    # create the A matrix by conacentating R_1 ... R_n with identity matrices
    A_1 = np.reshape(R_n, (3*n, 3))
    iden = np.identity(3)
    iden_n = -np.tile(iden, (n, 1))
    A = np.concatenate((A_1, iden_n), 1)

    # create b by concatenating p_1 ... p_n
    b = -np.reshape(p_n, (3*n, 1))

    # solve least squares
    x = np.linalg.lstsq(A, b)[0]

    b_tip, b_post = x[:3], x[3:]
    b_tip = np.squeeze(b_tip)
    b_post = np.squeeze(b_post)

    return b_tip, b_post
