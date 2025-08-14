# OpenSCAD file for the SparkFun GPS-RTK-SMA

Source file based on YAPP_Box [Demo RealBox - transmitter/receiver v3.0](https://github.com/mrWheel/YAPP_Box/blob/main/examples/YAPP_RidgeExtDemo_v30.scad)

> [!NOTE]
> Requires the [YAPP_Box](https://github.com/mrWheel/YAPP_Box) OpenSCAD library

- SKU: GPS-16481
- Product link: https://www.sparkfun.com/sparkfun-gps-rtk-sma-breakout-zed-f9p-qwiic.html

If you want the board STL, I couldn't find the SMA version, but the very similar U.FL board
can be found [here](https://grabcad.com/library/sparkfun-ublox-zed-f9p-gps-rtk-2-1). You will need to convert the 
STEP file into STL. 

I have some bottom pins that I left on the board in case I want to use them for powering the board
in future endeavors. The height of the base could be reduced for a slimmer case.

I did not include holes for the Qwiic connections, but using the schematic, it would be
fairly quick to add them to your OpenSCAD file and render an updated box.

# Printing parameters used

- 0.4mm nozzle
- 0.20mm layer height
- PLA
- No supports
- No raft
