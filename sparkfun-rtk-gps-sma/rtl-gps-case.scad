//-----------------------------------------------------------------------
// SparkFun GPS-RTK-SMA Breakout - ZED-F9P
//
//  Based on: Demo RealBox - transmitter/receiver
//  Version 3.0 (01-12-2023)
//
// This design is parameterized based on the size of a PCB.
//
//  You might need to adjust the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 250000 elements
//                                                  ^^^^^^
//
//-----------------------------------------------------------------------

inchesToMm = 25.4; // sparkfun schematic is in inches

// update to your local path where libraries are stored
include </home/maddog/.local/share/OpenSCAD/libraries/YAPP_Box/YAPPgenerator_v3.scad>

/*
Source STEP is here: 
You will need to convert to stl for OpenSCAD import
*/

if (true) {
  myPcb = "./UBLOX_ZED_F9P_GPS_RTK_2.stl";

  rotate([0,0,-90]) {
  translate([-45,3,10]) color("lightgray") import(myPcb);
  }
}

//-- switchBlock dimensions
switchWallThickness = 1;
switchWallHeight = 11;
switchLength = 15;
switchWidth = 13;

// Note: length/lengte refers to X axis, 
//       width/breedte to Y, 
//       height/hoogte to Z

/*
            padding-back>|<---- pcb length ---->|<padding-front
                                 RIGHT
                   0    X-ax ---> 
               +----------------------------------------+   ---
               |                                        |    ^
               |                                        |   padding-right 
             ^ |                                        |    v
             | |    -5,y +----------------------+       |   ---              
        B    Y |         | 0,y              x,y |       |     ^              F
        A    - |         |                      |       |     |              R
        C    a |         |                      |       |     | pcb width    O
        K    x |         |                      |       |     |              N
               |         | 0,0              x,0 |       |     v              T
               |   -5,0  +----------------------+       |   ---
               |                                        |    padding-left
             0 +----------------------------------------+   ---
               0    X-ax --->
                                 LEFT
*/

//-- which part(s) do you want to print?
printBaseShell = true;
printLidShell = true;
printSwitchExtenders = false;

//-- pcb dimensions -- very important!!!
pcbLength = 1.7*inchesToMm; // from schematic
pcbWidth = 1.7*inchesToMm; // from schematic
pcbThickness = 2.0; // measured

//-- padding between pcb and inside wall
paddingFront = 1;
paddingBack = 1;
paddingRight = 1;
paddingLeft = 0; 

//-- Edit these parameters for your own box dimensions
wallThickness = 1.8;
basePlaneThickness = 1.5;
lidPlaneThickness = 1.5;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight = 14;
lidWallHeight = 6;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight = 3.5;
ridgeSlack = 0.2;
roundRadius = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight = 4.0; //-- only used for showPCB
standoffPinDiameter = 2.2;
standoffHoleSlack = 0.4;
standoffDiameter = 4;

//-- C O N T R O L -------------//-> Default ---------
showSideBySide = false; //-> true
previewQuality = 5; //-> from 1 to 32, Default = 5
renderQuality = 8; //-> from 1 to 32, Default = 8
onLidGap = 0;
shiftLid = 5;
colorLid = "YellowGreen";
alphaLid = 0.8;
colorBase = "BurlyWood";
alphaBase = 0.8;
hideLidWalls = false; //-> false
hideBaseWalls = false; //-> false
showOrientation = true;
showPCB = false;
showSwitches = true;
showPCBmarkers = false;
showShellZero = false;
showCenterMarkers = false;
inspectX = 0; //-> 0=none (>0 from Back)
inspectY = 0; //-> 0=none (>0 from Right)
inspectZ = 0; //-> 0=none (>0 from Bottom)
inspectXfromBack = true; // View from the inspection cut foreward
inspectYfromLeft = true; //-> View from the inspection cut to the right
inspectZfromTop = false; //-> View from the inspection cut down
//-- C O N T R O L ---------------------------------------

//===================================================================
//   *** PCB Supports ***
//   Pin and Socket standoffs 
//-------------------------------------------------------------------
//  Default origin =  yappCoordPCB : pcb[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = posx
//    (1) = posy
//   Optional:
//    (2) = Height to bottom of PCB : Default = standoffHeight
//    (3) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcbThickness, yappCoordBox=0
//    (4) = standoffDiameter    Default = standoffDiameter;
//    (5) = standoffPinDiameter Default = standoffPinDiameter;
//    (6) = standoffHoleSlack   Default = standoffHoleSlack;
//    (7) = filletRadius (0 = auto size)
//    (n) = { <yappBoth> | yappLidOnly | yappBaseOnly }
//    (n) = { yappHole, <yappPin> } // Baseplate support treatment
//    (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    (n) = { yappCoordBox, <yappCoordPCB> }  
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------
pcbStands =
[
// 0               1               2     3   4    5
  [0.1*inchesToMm, 0.1*inchesToMm, 8.75, -1, 4.0, 2.5, yappBoth, yappPin, yappFrontLeft],
  [0.1*inchesToMm, 0.1*inchesToMm, 8.75, -1, 4.0, 2.5, yappBoth, yappPin, yappFrontRight],
  [0.1*inchesToMm, 0.1*inchesToMm, 8.75, -1, 4.0, 2.5, yappBoth, yappPin, yappBackLeft],
  [0.1*inchesToMm, 0.1*inchesToMm, 8.75, -1, 4.0, 2.5, yappBoth, yappPin, yappBackRight]
];

//===================================================================
//  *** Cutouts ***
//    There are 6 cutouts one for each surface:
//      cutoutsBase, cutoutsLid, cutoutsFront, cutoutsBack, cutoutsLeft, cutoutsRight
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//                        Required                Not Used        Note
//                      +-----------------------+---------------+------------------------------------
//  yappRectangle       | width, length         | radius        |
//  yappCircle          | radius                | width, length |
//  yappRoundedRect     | width, length, radius |               |     
//  yappCircleWithFlats | width, radius         | length        | length=distance between flats
//  yappCircleWithKey   | width, length, radius |               | width = key width length=key depth
//  yappPolygon         | width, length         | radius        | yappPolygonDef object must be provided
//
//  Parameters:
//   Required:
//    (0) = from Back
//    (1) = from Left
//    (2) = width
//    (3) = length
//    (4) = radius
//    (5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
//                   | yappCircleWithFlats | yappCircleWithKey}
//  Optional:
//    (6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
//    (7) = angle : Default = 0
//    (n) = { yappPolygonDef } : Required if shape = yappPolygon specified -
//    (n) = { yappMaskDef } : If a yappMaskDef object is added it will be used as a mask for the cutout.
//    (n) = { <yappCoordBox> | yappCoordPCB }
//    (n) = { <yappOrigin>, yappCenter }
//    (n) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top, Back and Right Faces
//-------------------------------------------------------------------

cutoutsFront =
[
  [26.18, 5.96, 9, 4.75, 0, yappRectangle, 4] //-- USB C
  //,
  //[47.1, 3.8, 9, 4, 0, yappRectangle, 4, yappCoordPCB], //-- MicroUSB
];


cutoutsBack =
[
  [20.25, 2.96, 9, 4.75, 4.5, yappCircle, 4] //-- USB C
];


//===================================================================
//  *** Snap Joins ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = posx | posy
//    (1) = width
//    (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
//   Optional:
//    (n) = { <yappOrigin> | yappCenter }
//    (n) = { yappSymmetric }
//    (n) = { yappRectangle } == Make a diamond shape snap
//-------------------------------------------------------------------
snapJoins =
[
  [15, 3, yappLeft, yappRight, yappCenter, yappSymmetric],
];

//===================================================================
//  *** Light Tubes ***
//-------------------------------------------------------------------
//  Default origin = yappCoordPCB: PCB[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//    p(2) = tubeLength
//    p(3) = tubeWidth
//    p(4) = tubeWall
//    p(5) = gapAbovePcb
//    p(6) = tubeType    {yappCircle|yappRectangle}
//   Optional:
//    p(7) = lensThickness (how much to leave on the top of the lid for the 
//           light to shine through 0 for open hole : Default = 0/Open
//    p(8) = Height to top of PCB : Default = standoffHeight+pcbThickness
//    p(9) = filletRadius : Default = 0/Auto 
//    n(a) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside } 
//    n(b) = { <yappGlobalOrigin>, yappLeftOrigin }
//    n(c) = { yappNoFillet }
//-------------------------------------------------------------------

lightTubes =
[
  // disable or maybe adjust (5) to suit your preferences
  ///0   1     2    3     4  5
  [4.90, 12.6, 2.5, 7.25, 1, 5.5, yappRectangle],
];


//========= MAIN CALL's ===========================================================

//---- This is where the magic happens ----
YAPPgenerate();
