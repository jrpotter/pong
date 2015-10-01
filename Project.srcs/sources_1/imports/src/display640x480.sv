//////////////////////////////////////////////////////////////////////////////////
//
// Joshua Potter (Revised from Montek Singh)
// 4/15/2015
//
// Properties related to the VGA display driver. These include custom made
// characters (in which color data is stored in bitmap memory).
//
//////////////////////////////////////////////////////////////////////////////////


// Frame Properties
// ===========================================

`define WholeLine  800   // x lies in [0..WholeLine-1]
`define WholeFrame 525   // y lies in [0..WholeFrame-1]

`define xbits $clog2(`WholeLine)  // how many bits needed to count x?
`define ybits $clog2(`WholeFrame) // how many bits needed to count y?


// Horizontal/Vertical Syncs
// ===========================================

`define hFrontPorch 16
`define hBackPorch 48
`define hSyncPulse 96
`define vFrontPorch 10
`define vBackPorch 33
`define vSyncPulse 2

`define hSyncPolarity 1'b1
`define vSyncPolarity 1'b1

`define hSyncStart (`WholeLine - `hBackPorch - `hSyncPulse)
`define hSyncEnd (`hSyncStart + `hSyncPulse - 1)
`define vSyncStart (`WholeFrame - `vBackPorch - `vSyncPulse)
`define vSyncEnd (`vSyncStart + `vSyncPulse - 1)

`define hVisible (`WholeLine  - `hFrontPorch - `hSyncPulse - `hBackPorch)
`define vVisible (`WholeFrame - `vFrontPorch - `vSyncPulse - `vBackPorch)


// Character Properties
// ===========================================

`define charSize 256      // (charWidth * charHeight)
`define charWidth 16
`define charHeight 16
`define charRowCount 30   // (480 / charHeight)
`define charColCount 40   // (640 / charWidth)


// Character Convenience Properties
// ===========================================

`define charWidthShift $clog2(`charWidth)
`define charHeightShift $clog2(`charHeight)
