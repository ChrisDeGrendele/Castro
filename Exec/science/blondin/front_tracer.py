#!/usr/bin/env python3
import sys
import yt
import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import UnivariateSpline

plotfiles= list(sys.argv[1:])

r = []
t = []

for plot in plotfiles:
    ds = yt.load(plot)
    slice = ds.slice(1, 0)
    shock_loc = slice.argmax("density", axis='r')
    time = ds.current_time
    r.append(shock_loc)
    t.append(time)

plt.scatter(t,r)
plt.xlabel('Time [seconds]')
plt.ylabel('Radius [cm]')
plt.title('Radius vs Time')
plt.savefig("r_v_st.png")


spl = UnivariateSpline(t,r)
v = spl.derivative()
#print(v)
plt.scatter(t,v(t))
plt.xlabel('Time [seconds]')
plt.ylabel('Velocity [cm]')
plt.title('Velocity vs Time')
plt.savefig("v_v_st.png")


    


