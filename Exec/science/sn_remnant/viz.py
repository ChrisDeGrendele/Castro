import yt

ds = yt.load("plt00035")
sl = yt.SlicePlot(ds, 2, 'temperature')
sl.save("viz.png")
