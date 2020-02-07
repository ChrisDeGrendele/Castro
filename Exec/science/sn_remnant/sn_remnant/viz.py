import yt
import numpy as np
import glob


plotfiles = glob.glob("plt*")

for plot in plotfiles:
    ds = yt.load(plot)
    sl = yt.sl = yt.SlicePlot(ds, 1, 'density')
    text_string = "T = {} Gyr".format(float(ds.current_time.to('yr')))
    
    sl.save("viz"+plot+".png")
#    sl.save_annotated("viz"+plot+".png",
#                  text_annotate=[[(.1, 0.95), text_string]])


'''


x = np.linspace(0, 1500, 4, dtype=int)
print(x)
x = np.append(x,1596)
x.astype(int)
print(x)
for i in x:
    if i == 0:
        ds = yt.load("plt00000")
        sl = yt.SlicePlot(ds, 1, 'temperature')
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
'''
