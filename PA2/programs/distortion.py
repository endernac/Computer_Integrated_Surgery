import scipy.special
import numpy as np
from numpy import linalg


def B(x, n, v):
    """
    Computes Bertstein polynomial term
    :param x: x value for Bertnstein polynomial
    :param n: Bernstein polynomial degree
    :param v: Order of Bernstein polynomial term
    :return: Value of the vth term in a n-degree Bernstein polynomial
    """
    return scipy.special.comb(n, v) * x**v * (1-x)**(n-v)


def getbasis(p, n):
    """
    Calculates the basis for points with respect to unit box
    :param p: Coordinates
    :param n: Degree
    :return: Basis for Bernstein polynomial
    """
    l = []
    for i in range(p.shape[1]):
        for v in range(n):
            l.append(B(p[:,i], n, v))
    l = np.array(l)
    return l.T


def getcoeff(obs, expect, n):
    """
    Get Bernstein coefficients for best fit between observed and expected coordinates
    :param obs: Array of observed vectors
    :param expect: Array of expected vectors
    :param n: Bernstein polynomial degree
    :return: Array of coefficients for Bernstein polynomial fit
    """
    l = getbasis(obs, n)
    coeff = []
    for i in range(3):
        f = np.linalg.lstsq(l, expect[:, i] - obs[:, i])[0]
        coeff.append(f)
    return np.array(coeff)


def undist(coeff, coords):
    """
    Undistort using Bernstein polynomial coefficients
    :param coeff: Array of Bernstein polynomial coefficients
    :param coords: Array of coordinates
    :return: Array of undistorted coordinates
    """
    basis = getbasis(coords, 20)
    x_und = (coeff[0] * basis).sum(axis=1)
    y_und = (coeff[1] * basis).sum(axis=1)
    z_und = (coeff[2] * basis).sum(axis=1)

    coord_und = np.array([x_und, y_und, z_und]).T
    return coord_und