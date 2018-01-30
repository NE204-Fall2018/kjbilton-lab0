"""Fitting routines used for HPGe energy calibration"""

import numpy as np
from scipy.optimize import curve_fit

def gaussian(x, a, mu, sigma):
    """ A simple Gaussian function
    Parameters
    ==========
    x : array
        Data points used in Gaussian
    a : float
        Amplitude of Gaussian
    mu : float
        Mean of Gaussian
    sigma : float
        Standard deviation of Gaussian
    """
    return a * np.exp(-(x - mu)**2 / 2 / sigma**2)


def fit_gaus_window(spectrum, low, high, p0=None):
    """ Fit a Gaussian over the specified window.

    Parameters
    ==========
    spectrum : numpy array or Pandas series
        Spectrum containing data to be fit.
    low : int
        Lower bound of fitting region.
    high : int
        Upper bound of fitting region.
    p0 : array-like, shape (n_parameters)
        List of initial estimates of parameters in the form [A, mu, sigma]

    Outputs
    =======
    popt : numpy array, shape (n_parameters)
        Optimized parameters
    pcov : numpy array
        Covariance matrix describing fit
    """
    assert low < high
    y = np.array(spectrum[low:high])
    x = np.arange(low, high)

    popt, pcov = curve_fit(gaussian, x, y, p0=p0)

    return popt, pcov

def generate_X(x, D):
    """ Generate the feature matrix X using the values of x from powers 1 to D

    Parameters
    ==========
    x : array of data points
    D : power that data points are fit

    Outputs
    =======
    X : array, shape (n, D)
        Feature matrix
    """
    # Create a container for the feature matrix
    X = np.empty((x.shape[0], (D + 1)))

    # Make each column of the feature matrix a power of the data vector x
    for idx in range(D+1):
        X[:, idx] = x**idx

    return X

def lstsq(A, b):
    """ Perform least squares fitting for Ax = b

    Parameters
    ==========
    A : array, shape (n, D)
        Feature matrix
    b : array, shape (n, )
        Vector of target values (i.e., energies)

    Outputs
    =======
    x : array, shape (D, )
        Least squares weights for model order D
    """
    return np.linalg.solve(A.T @ A, A.T @ b)

def lstsq_err(A, b, x):
    """ Compute the average squared error for each data point

    Parameters
    ==========
    A : array, shape (n, D)
        Feature matrix
    b : array, shape (n, )
        Vector of target values (i.e., energies)
    x : array, shape (D, )
        Least squares weights for model order D

    Outputs
    =======
    err : float
        Mean error for the given data
    """
    return (b - A @ x).T @ (b - A @ x).T / b.shape[0]
