import yt
import numpy as np

x = np.linspace(0, 1550, 32, dtype=int)
print(x)
x = np.append(x,1589)
x.astype(int)
print(x)
for i in x:
    if i == 0:
        ds = yt.load("plt00000")
        sl = yt.SlicePlot(ds, 2, 'temperature')
        sl.save("viz00000.png")
    elif i < 100:
        ds = yt.load("plt000{}".format(i))
        sl = yt.SlicePlot(ds, 2, 'temperature')
        sl.save("viz000{}.png".format(i))
    elif i < 1000:
        ds = yt.load("plt00{}".format(i))
        sl = yt.SlicePlot(ds, 2, 'temperature')
        sl.save("viz00{}.png".format(i))
    elif i < 10000:
        ds = yt.load("plt0{}".format(i))
        sl = yt.SlicePlot(ds, 2, 'temperature')
        sl.save("viz0{}.png".format(i))
