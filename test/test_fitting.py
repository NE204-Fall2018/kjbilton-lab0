"""Tests for fitting routines"""
from scripts.fitting import gaussian, fit_gaus_window
import numpy as np
import pytest

def test_gaussian_symmetry():
    assert gaussian(1, 2, 0, 4) == gaussian(-1, 2, 0, 4)

def test_gaussian_value():
    assert np.isclose(gaussian(np.sqrt(2), 1, 0, 1), 1 / np.e)

def test_bad_windows():
    with pytest.raises(AssertionError):
        low = 100
        high = 10
        fit_gaus_window(np.arange(1, 1001), low, high)
