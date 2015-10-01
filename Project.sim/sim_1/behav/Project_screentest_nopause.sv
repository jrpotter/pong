`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 4/15/2015 
//
// PLEASE README!
// ==============
//
// This is a self-checking tester for your full MIPS processor 
// plus memory-mapped IO.
//
// Use this tester carefully!  The names of your top-level input/output
// and internal signals may be different, so modify all of signal names on the
// right-hand-side of the "wire" assigments appearing above the uut
// instantiation.  Observe that the uut itself only has clock and reset inputs
// now, and no debug outputs.  Also, the parameters specifying the names of the
// memory initialization files must match the actual file names.
//
// If you decide not to use some of these internal signals for debugging, you
// may comment the relevant lines out.  Be sure to comment out the
// corresponding "ERROR_*" lines below as well.
//
// Finally, note that in my bitmap memory, each 12-bit color is encoded as
// RRRRGGGGBBBB (i.e., red is most significant).  If you have chosen a different
// order for the red/green/blue color values, you may see ERROR signals for the
// colors light up, but there is no error if you are consistent with your
// RGB ordering.
//
//////////////////////////////////////////////////////////////////////////////////


module project_screentest;

	// Inputs
	reg clk;
	reg reset;

	// Signals inside top-level module uut
	wire [31:0] pc             =uut.pc;                    // PC
	wire [31:0] instr          =uut.instr;                 // instr coming out of instr mem
	wire [31:0] mem_addr       =uut.mem_addr;              // addr sent to data mem
	wire        mem_wr         =uut.mem_wr;                // write enable for data mem
	wire [31:0] mem_readdata   =uut.mem_readdata;          // data read from data mem
	wire [31:0] mem_writedata  =uut.mem_writedata;         // write data for data mem
	
	// Signals inside module uut.mips
    wire        werf           =uut.mips.werf;              // WERF = write enable for register file
    wire  [4:0] alufn          =uut.mips.alufn;             // ALU function
    wire        Z              =uut.mips.Z;                 // Zero flag

	// Signals inside module uut.mips.dp (datapath)
    wire [31:0] ReadData1      =uut.mips.dp.ReadData1;       // Reg[rs]
    wire [31:0] ReadData2      =uut.mips.dp.ReadData2;       // Reg[rt]
    wire [31:0] alu_result     =uut.mips.dp.alu_result;      // ALU's output
    wire [4:0]  reg_writeaddr  =uut.mips.dp.reg_writeaddr;   // destination register
    wire [31:0] reg_writedata  =uut.mips.dp.reg_writedata;   // write data for register file
    wire [31:0] signImm        =uut.mips.dp.signImm;         // sign-/zero-extended immediate
    wire [31:0] aluA           =uut.mips.dp.aluA;            // operand A for ALU
    wire [31:0] aluB           =uut.mips.dp.aluB;            // operand B for ALU

	// Signals inside module uut.mips.c (controller)
    wire [1:0] pcsel           =uut.mips.c.pcsel;
    wire [1:0] wasel           =uut.mips.c.wasel;
    wire sext                  =uut.mips.c.sext;
    wire bsel                  =uut.mips.c.bsel;
    wire [1:0] wdsel           =uut.mips.c.wdsel;
    wire wr                    =uut.mips.c.wr;
    wire [1:0] asel            =uut.mips.c.asel;

	// Signals related to module memIO (memory + memory-mapped IO)
	wire [10:0] smem_addr      =uut.smem_addr;             // address from vgadisplaydriver to access screen mem
	wire [3:0]  charcode       =uut.charcode;              // character code returned by screen mem
	wire dmem_wr               =uut.memIO.dmem_wr;
	wire smem_wr               =uut.memIO.smem_wr;

	// Signals related to module vgadisplaydriver (display driver)
    wire hsync                 =uut.hsync;
    wire vsync                 =uut.vsync;
    wire [3:0] red             =uut.red;
    wire [3:0] green           =uut.green;
    wire [3:0] blue            =uut.blue;
    wire [9:0] x               =uut.displaydriver.x;
	wire [9:0] y               =uut.displaydriver.y;
	wire [11:0] bmem_addr      =uut.displaydriver.bitmapAddr;
	wire [11:0] bmem_color     =uut.displaydriver.colorValue;
	

	// Instantiate the Unit Under Test (UUT)
	top #("imem.txt", "dmem.txt", "smem.txt", "bmem.txt") uut(
	       .clk(clk), 
	       .reset(reset)
	);

//
// CHECK ALL VALUES ABOVE THIS LINE
// YOU SHOULD NOT NEED TO MODIFY ANYTHING BELOW
//

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
   end

   initial begin
      #0.5 clk = 0;
      forever
         #0.5 clk = ~clk;
   end
   
   initial begin
      #50 $finish;
   end
   
   
   
   // SELF-CHECKING CODE
   
   selfcheck c();

	wire [31:0] c_pc=c.pc;
	wire [31:0] c_instr=c.instr;
	wire [31:0] c_mem_addr=c.mem_addr;
	wire        c_mem_wr=c.mem_wr;
	wire [31:0] c_mem_readdata=c.mem_readdata;
	wire [31:0] c_mem_writedata=c.mem_writedata;
    wire        c_werf=c.werf;
    wire  [4:0] c_alufn=c.alufn;
    wire        c_Z=c.Z;
    wire [31:0] c_ReadData1=c.ReadData1;
    wire [31:0] c_ReadData2=c.ReadData2;
    wire [31:0] c_alu_result=c.alu_result;
    wire [4:0]  c_reg_writeaddr=c.reg_writeaddr;
    wire [31:0] c_reg_writedata=c.reg_writedata;
    wire [31:0] c_signImm=c.signImm;
    wire [31:0] c_aluA=c.aluA;
    wire [31:0] c_aluB=c.aluB;
    wire [1:0]  c_pcsel=c.pcsel;
    wire [1:0]  c_wasel=c.wasel;
    wire        c_sext=c.sext;
    wire        c_bsel=c.bsel;
    wire [1:0]  c_wdsel=c.wdsel;
    wire        c_wr=c.wr;
    wire [1:0]  c_asel=c.asel;
    wire [10:0] c_smem_addr=c.smem_addr;
    wire [3:0]  c_charcode=c.charcode;
    wire        c_dmem_wr=c.dmem_wr;
    wire        c_smem_wr=c.smem_wr;
    wire        c_hsync=c.hsync;
    wire        c_vsync=c.vsync;
    wire [3:0]  c_red=c.red;
    wire [3:0]  c_green=c.green;
    wire [3:0]  c_blue=c.blue;
    wire [9:0]  c_x=c.x;
    wire [9:0]  c_y=c.x;
    wire [11:0] c_bmem_addr=c.bmem_addr;
    wire [11:0] c_bmem_color=c.bmem_color;

  
    function mismatch;  // some trickery needed to match two values with don't cares
        input p, q;      // mismatch in a bit position is ignored if q has an 'x' in that bit
        integer p, q;
        mismatch = (((p ^ q) ^ q) !== q);
    endfunction

    wire ERROR = ERROR_pc | ERROR_instr | ERROR_mem_addr | ERROR_mem_wr | ERROR_mem_readdata 
              | ERROR_mem_writedata | ERROR_werf | ERROR_alufn | ERROR_Z
              | ERROR_ReadData1 | ERROR_ReadData2 | ERROR_alu_result | ERROR_reg_writeaddr
              | ERROR_reg_writedata | ERROR_signImm | ERROR_aluA | ERROR_aluB
              | ERROR_pcsel | ERROR_wasel | ERROR_sext | ERROR_bsel | ERROR_wdsel | ERROR_wr | ERROR_asel
              | ERROR_smem_addr | ERROR_charcode | ERROR_dmem_wr | ERROR_smem_wr | ERROR_hsync | ERROR_vsync
              | ERROR_red | ERROR_green | ERROR_blue | ERROR_x | ERROR_y | ERROR_bmem_addr | ERROR_bmem_color;

   
    wire ERROR_pc             = mismatch(pc, c.pc) ? 1'bx : 1'b0;
	wire ERROR_instr          = mismatch(instr, c.instr) ? 1'bx : 1'b0;
	wire ERROR_mem_addr       = mismatch(mem_addr, c.mem_addr) ? 1'bx : 1'b0;
	wire ERROR_mem_wr         = mismatch(mem_wr, c.mem_wr) ? 1'bx : 1'b0;
	wire ERROR_mem_readdata   = mismatch(mem_readdata, c.mem_readdata) ? 1'bx : 1'b0;
	wire ERROR_mem_writedata  = c.mem_wr & (mismatch(mem_writedata, c.mem_writedata) ? 1'bx : 1'b0);
    wire ERROR_werf           = mismatch(werf, c.werf) ? 1'bx : 1'b0;
    wire ERROR_alufn          = mismatch(alufn, c.alufn) ? 1'bx : 1'b0;
    wire ERROR_Z              = mismatch(Z, c.Z) ? 1'bx : 1'b0;
    wire ERROR_ReadData1      = mismatch(ReadData1, c.ReadData1) ? 1'bx : 1'b0;
    wire ERROR_ReadData2      = mismatch(ReadData2, c.ReadData2) ? 1'bx : 1'b0;
    wire ERROR_alu_result     = mismatch(alu_result, c.alu_result) ? 1'bx : 1'b0;
    wire ERROR_reg_writeaddr  = c.werf & (mismatch(reg_writeaddr, c.reg_writeaddr) ? 1'bx : 1'b0);
    wire ERROR_reg_writedata  = c.werf & (mismatch(reg_writedata, c.reg_writedata) ? 1'bx : 1'b0);
    wire ERROR_signImm        = mismatch(signImm, c.signImm) ? 1'bx : 1'b0;
    wire ERROR_aluA           = mismatch(aluA, c.aluA) ? 1'bx : 1'b0;
    wire ERROR_aluB           = mismatch(aluB, c.aluB) ? 1'bx : 1'b0;
    wire ERROR_pcsel          = mismatch(pcsel, c.pcsel) ? 1'bx : 1'b0;
    wire ERROR_wasel          = c.werf & (mismatch(wasel, c.wasel) ? 1'bx : 1'b0);
    wire ERROR_sext           = mismatch(sext, c.sext) ? 1'bx : 1'b0;
    wire ERROR_bsel           = mismatch(bsel, c.bsel) ? 1'bx : 1'b0;
    wire ERROR_wdsel          = mismatch(wdsel, c.wdsel) ? 1'bx : 1'b0;
    wire ERROR_wr             = mismatch(wr, c.wr) ? 1'bx : 1'b0;
    wire ERROR_asel           = mismatch(asel, c.asel) ? 1'bx : 1'b0;
    wire ERROR_smem_addr      = mismatch(smem_addr, c.smem_addr) ? 1'bx : 1'b0;
    wire ERROR_charcode       = mismatch(charcode, c.charcode) ? 1'bx : 1'b0;
    wire ERROR_dmem_wr        = mismatch(dmem_wr, c.dmem_wr) ? 1'bx : 1'b0;
    wire ERROR_smem_wr        = mismatch(smem_wr, c.smem_wr) ? 1'bx : 1'b0;
    wire ERROR_hsync          = mismatch(hsync, c.hsync) ? 1'bx : 1'b0;
    wire ERROR_vsync          = mismatch(vsync, c.vsync) ? 1'bx : 1'b0;
    wire ERROR_red            = mismatch(red, c.red) ? 1'bx : 1'b0;
    wire ERROR_green          = mismatch(green, c.green) ? 1'bx : 1'b0;
    wire ERROR_blue           = mismatch(blue, c.blue) ? 1'bx : 1'b0;
    wire ERROR_x              = mismatch(x, c.x) ? 1'bx : 1'b0;
    wire ERROR_y              = mismatch(y, c.y) ? 1'bx : 1'b0;
    wire ERROR_bmem_addr      = mismatch(bmem_addr, c.bmem_addr) ? 1'bx : 1'b0;
    wire ERROR_bmem_color     = mismatch(bmem_color, c.bmem_color) ? 1'bx : 1'b0;

    //initial begin
    //    $monitor("#%02d {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h%h, 32'h%h, 32'h%h, 1'b%b, 32'h%h, 32'h%h, 1'b%b, 5'b%b, 1'b%b, 32'h%h, 32'h%h, 32'h%h, 5'h%h, 32'h%h, 32'h%h, 32'h%h, 32'h%h, 2'b%b, 2'b%b, 1'b%b, 1'b%b, 2'b%b, 1'b%b, 2'b%b};",
    //        $time, pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel);
    //    $monitor("#%02d {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h%h, 4'h%h, 1'b%b, 1'b%b, 1'b%b, 1'b%b, 4'h%h, 4'h%h, 4'h%h, 10'h%h, 10'h%h, 12'h%h, 12'h%h};",
    //            $time, smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color);
    //end

endmodule



// CHECKER MODULE
module selfcheck();
	reg  [31:0] pc;
	reg  [31:0] instr;
	reg  [31:0] mem_addr;
	reg         mem_wr;
	reg  [31:0] mem_readdata;
	reg  [31:0] mem_writedata;
    reg         werf;
    reg   [4:0] alufn;
    reg         Z;
    reg  [31:0] ReadData1;
    reg  [31:0] ReadData2;
    reg  [31:0] alu_result;
    reg  [4:0]  reg_writeaddr;
    reg  [31:0] reg_writedata;
    reg  [31:0] signImm;
    reg  [31:0] aluA;
    reg  [31:0] aluB;
    reg  [1:0] pcsel;
    reg  [1:0] wasel;
    reg        sext;
    reg        bsel;
    reg  [1:0] wdsel;
    reg        wr;
    reg  [1:0] asel;
    reg [10:0] smem_addr;
    reg [3:0]  charcode;
    reg dmem_wr;
    reg smem_wr;
    reg hsync;
    reg vsync;
    reg [3:0] red;
    reg [3:0] green;
    reg [3:0] blue;
    reg [9:0] x;
    reg [9:0] y;
    reg [11:0] bmem_addr;
    reg [11:0] bmem_color;
    
initial begin
fork

#00 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00000000, 32'h00000020, 32'h00000000, 1'b0, 32'h00000000, 32'h00000000, 1'b1, 5'b0xx01, 1'b1, 32'h00000000, 32'h00000000, 32'h00000000, 5'h00, 32'h00000000, 32'h00000020, 32'h00000000, 32'h00000000, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
#00 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h0, 1'b0, 1'b0, 1'b1, 1'b1, 4'hf, 4'h0, 4'h0, 10'h000, 10'h000, 12'h000, 12'hf00};
#01 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00000004, 32'h201d203c, 32'h0000203c, 1'b0, 32'hxxxxxxxx, 32'hxxxxxxxx, 1'b1, 5'b0xx01, 1'b0, 32'h00000000, 32'hxxxxxxxx, 32'h0000203c, 5'h1d, 32'h0000203c, 32'h0000203c, 32'h00000000, 32'h0000203c, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
#02 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00000008, 32'h20040000, 32'h00000000, 1'b0, 32'h00000000, 32'hxxxxxxxx, 1'b1, 5'b0xx01, 1'b1, 32'h00000000, 32'hxxxxxxxx, 32'h00000000, 5'h04, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
#03 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h0000000c, 32'h0c000009, 32'hxxxxxxxx, 1'b0, 32'hxxxxxxxx, 32'h00000000, 1'b1, 5'bxxxxx, 1'bx, 32'h00000000, 32'h00000000, 32'hxxxxxxxx, 5'h1f, 32'h00000010, 32'h00000009, 32'hxxxxxxxx, 32'h0000000X, 2'b10, 2'b10, 1'bx, 1'bx, 2'b00, 1'b0, 2'bxx};
#04 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00000024, 32'h23bdfff8, 32'h00002034, 1'b0, 32'hxxxxxxxx, 32'h0000203c, 1'b1, 5'b0xx01, 1'b0, 32'h0000203c, 32'h0000203c, 32'h00002034, 5'h1d, 32'h00002034, 32'hfffffff8, 32'h0000203c, 32'hfffffff8, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
#04 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h0, 1'b0, 1'b0, 1'b1, 1'b1, 4'hf, 4'h0, 4'h0, 10'h001, 10'h000, 12'h001, 12'hf00};
#05 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00000028, 32'hafbf0004, 32'h00002038, 1'b1, 32'hxxxxxxxx, 32'h00000010, 1'b0, 5'b0xx01, 1'b0, 32'h00002034, 32'h00000010, 32'h00002038, 5'hxx, 32'hxxxxxxxx, 32'h00000004, 32'h00002034, 32'h00000004, 2'b00, 2'bxx, 1'b1, 1'b1, 2'bxx, 1'b1, 2'b00};
#05 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h0, 1'b1, 1'b0, 1'b1, 1'b1, 4'hf, 4'h0, 4'h0, 10'h001, 10'h000, 12'h001, 12'hf00};
#06 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h0000002c, 32'hafa40000, 32'h00002034, 1'b1, 32'hxxxxxxxx, 32'h00000000, 1'b0, 5'b0xx01, 1'b0, 32'h00002034, 32'h00000000, 32'h00002034, 5'hxx, 32'hxxxxxxxx, 32'h00000000, 32'h00002034, 32'h00000000, 2'b00, 2'bxx, 1'b1, 1'b1, 2'bxx, 1'b1, 2'b00};
#07 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00000030, 32'h00042400, 32'h00000000, 1'b0, 32'h00000000, 32'h00000000, 1'b1, 5'bx0010, 1'b1, 32'h00000000, 32'h00000000, 32'h00000000, 5'h04, 32'h00000000, 32'h00002400, 32'h00000010, 32'h00000000, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b01};
#07 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h0, 1'b0, 1'b0, 1'b1, 1'b1, 4'hf, 4'h0, 4'h0, 10'h001, 10'h000, 12'h001, 12'hf00};
#08 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h0, 1'b0, 1'b0, 1'b1, 1'b1, 4'hf, 4'h0, 4'h0, 10'h002, 10'h000, 12'h002, 12'hf00};
#08 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00000034, 32'h10800002, 32'h00000000, 1'b0, 32'h00000000, 32'h00000000, 1'b0, 5'b1xx01, 1'b1, 32'h00000000, 32'h00000000, 32'h00000000, 5'hxx, 32'hxxxxxxxx, 32'h00000002, 32'h00000000, 32'h00000000, 2'b01, 2'bxx, 1'b1, 1'b0, 2'bxx, 1'b0, 2'b00};
#09 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00000040, 32'h8fa40000, 32'h00002034, 1'b0, 32'h00000000, 32'h00000000, 1'b1, 5'b0xx01, 1'b0, 32'h00002034, 32'h00000000, 32'h00002034, 5'h04, 32'h00000000, 32'h00000000, 32'h00002034, 32'h00000000, 2'b00, 2'b01, 1'b1, 1'b1, 2'b10, 1'b0, 2'b00};
#10 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00000044, 32'h8fbf0004, 32'h00002038, 1'b0, 32'h00000010, 32'h00000010, 1'b1, 5'b0xx01, 1'b0, 32'h00002034, 32'h00000010, 32'h00002038, 5'h1f, 32'h00000010, 32'h00000004, 32'h00002034, 32'h00000004, 2'b00, 2'b01, 1'b1, 1'b1, 2'b10, 1'b0, 2'b00};
#11 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00000048, 32'h23bd0008, 32'h0000203c, 1'b0, 32'hxxxxxxxx, 32'h00002034, 1'b1, 5'b0xx01, 1'b0, 32'h00002034, 32'h00002034, 32'h0000203c, 5'h1d, 32'h0000203c, 32'h00000008, 32'h00002034, 32'h00000008, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
#12 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h0000004c, 32'h03e00008, 32'hxxxxxxxx, 1'b0, 32'hxxxxxxxx, 32'h00000000, 1'b0, 5'bxxxxx, 1'bx, 32'h00000010, 32'h00000000, 32'hxxxxxxxx, 5'hxx, 32'hxxxxxxxx, 32'h00000008, 32'hxxxxxxxx, 32'h0000000X, 2'b11, 2'bxx, 1'bx, 1'bx, 2'bxx, 1'b0, 2'bxx};
#12 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h0, 1'b0, 1'b0, 1'b1, 1'b1, 4'hf, 4'h0, 4'h0, 10'h003, 10'h000, 12'h003, 12'hf00};
#13 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00000010, 32'h20080002, 32'h00000002, 1'b0, 32'h00000000, 32'hxxxxxxxx, 1'b1, 5'b0xx01, 1'b0, 32'h00000000, 32'hxxxxxxxx, 32'h00000002, 5'h08, 32'h00000002, 32'h00000002, 32'h00000000, 32'h00000002, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
#14 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00000014, 32'hac084000, 32'h00004000, 1'b1, 32'h00000000, 32'h00000002, 1'b0, 5'b0xx01, 1'b0, 32'h00000000, 32'h00000002, 32'h00004000, 5'hxx, 32'hxxxxxxxx, 32'h00004000, 32'h00000000, 32'h00004000, 2'b00, 2'bxx, 1'b1, 1'b1, 2'bxx, 1'b1, 2'b00};
#14 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h0, 1'b0, 1'b1, 1'b1, 1'b1, 4'hf, 4'h0, 4'h0, 10'h003, 10'h000, 12'h003, 12'hf00};
#15 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00000018, 32'h20080003, 32'h00000003, 1'b0, 32'h00000000, 32'h00000002, 1'b1, 5'b0xx01, 1'b0, 32'h00000000, 32'h00000002, 32'h00000003, 5'h08, 32'h00000003, 32'h00000003, 32'h00000000, 32'h00000003, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
#15 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h2, 1'b0, 1'b0, 1'b1, 1'b1, 4'h0, 4'h0, 4'hf, 10'h003, 10'h000, 12'h203, 12'h00f};
#16 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h0000001c, 32'hac084001, 32'h00004001, 1'b1, 32'h00000001, 32'h00000003, 1'b0, 5'b0xx01, 1'b0, 32'h00000000, 32'h00000003, 32'h00004001, 5'hxx, 32'hxxxxxxxx, 32'h00004001, 32'h00000000, 32'h00004001, 2'b00, 2'bxx, 1'b1, 1'b1, 2'bxx, 1'b1, 2'b00};
#16 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h2, 1'b0, 1'b1, 1'b1, 1'b1, 4'h0, 4'h0, 4'hf, 10'h004, 10'h000, 12'h204, 12'h00f};
#17 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00000020, 32'h08000008, 32'hxxxxxxxx, 1'b0, 32'hxxxxxxxx, 32'h00000000, 1'b0, 5'bxxxxx, 1'bx, 32'h00000000, 32'h00000000, 32'hxxxxxxxx, 5'hxx, 32'hxxxxxxxx, 32'h00000008, 32'hxxxxxxxx, 32'h0000000X, 2'b10, 2'bxx, 1'bx, 1'bx, 2'bxx, 1'b0, 2'bxx};
#17 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h2, 1'b0, 1'b0, 1'b1, 1'b1, 4'h0, 4'h0, 4'hf, 10'h004, 10'h000, 12'h204, 12'h00f};
#20 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h2, 1'b0, 1'b0, 1'b1, 1'b1, 4'h0, 4'h0, 4'hf, 10'h005, 10'h000, 12'h205, 12'h00f};
#24 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h2, 1'b0, 1'b0, 1'b1, 1'b1, 4'h0, 4'h0, 4'hf, 10'h006, 10'h000, 12'h206, 12'h00f};
#28 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h2, 1'b0, 1'b0, 1'b1, 1'b1, 4'h0, 4'h0, 4'hf, 10'h007, 10'h000, 12'h207, 12'h00f};
#32 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h2, 1'b0, 1'b0, 1'b1, 1'b1, 4'h0, 4'h0, 4'hf, 10'h008, 10'h000, 12'h208, 12'h00f};
#36 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h2, 1'b0, 1'b0, 1'b1, 1'b1, 4'h0, 4'h0, 4'hf, 10'h009, 10'h000, 12'h209, 12'h00f};
#40 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h2, 1'b0, 1'b0, 1'b1, 1'b1, 4'h0, 4'h0, 4'hf, 10'h00a, 10'h000, 12'h20a, 12'h00f};
#44 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h2, 1'b0, 1'b0, 1'b1, 1'b1, 4'h0, 4'h0, 4'hf, 10'h00b, 10'h000, 12'h20b, 12'h00f};
#48 {smem_addr, charcode, dmem_wr, smem_wr, hsync, vsync, red, green, blue, x, y, bmem_addr, bmem_color} <= {11'h000, 4'h2, 1'b0, 1'b0, 1'b1, 1'b1, 4'h0, 4'h0, 4'hf, 10'h00c, 10'h000, 12'h20c, 12'h00f};

join
end

endmodule