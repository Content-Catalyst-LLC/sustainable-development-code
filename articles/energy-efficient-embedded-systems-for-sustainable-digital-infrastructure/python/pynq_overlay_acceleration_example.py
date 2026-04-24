from pynq import Overlay, allocate
import numpy as np

ol = Overlay("edge_filter_accel.bit")

dma = ol.axi_dma_0
ip = ol.my_filter_accel_0

n = 1024
inp = allocate(shape=(n,), dtype=np.int16)
out = allocate(shape=(n,), dtype=np.int16)

inp[:] = np.random.randint(-100, 100, size=n, dtype=np.int16)

ip.write(0x10, n)
ip.write(0x00, 0x01)

dma.sendchannel.transfer(inp)
dma.recvchannel.transfer(out)

dma.sendchannel.wait()
dma.recvchannel.wait()

print(out[:16])
