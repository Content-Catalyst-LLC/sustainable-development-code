from pynq import Overlay, allocate
import numpy as np

ol = Overlay("agri_filter.bit")
dma = ol.axi_dma_0
accel = ol.filter_accel_0

n = 2048
sensor_in = allocate(shape=(n,), dtype=np.uint16)
filtered_out = allocate(shape=(n,), dtype=np.uint16)

sensor_in[:] = np.random.randint(0, 4096, size=n, dtype=np.uint16)

accel.write(0x10, n)
accel.write(0x00, 0x01)

dma.sendchannel.transfer(sensor_in)
dma.recvchannel.transfer(filtered_out)

dma.sendchannel.wait()
dma.recvchannel.wait()

print(filtered_out[:16])
