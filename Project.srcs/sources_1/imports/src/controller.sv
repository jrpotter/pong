`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 3/26/2015 
//
//////////////////////////////////////////////////////////////////////////////////

// These are non-R-type, so check op code
`define LW     6'b100011
`define SW     6'b101011
`define ADDI   6'b001000
`define SLTI   6'b001010
`define ORI    6'b001101
`define BEQ    6'b000100
`define BNE    6'b000101
`define J      6'b000010
`define JAL    6'b000011
`define LUI    6'b001111

// These are all R-type, i.e., op=0, so check the func field
`define ADD    6'b100000
`define SUB    6'b100010
`define AND    6'b100100
`define OR     6'b100101
`define XOR    6'b100110
`define NOR    6'b100111
`define SLT    6'b101010
`define SLTU   6'b101011
`define SLL    6'b000000
`define SLLV   6'b000100
`define SRL    6'b000010
`define SRA    6'b000011
`define JR     6'b001000  


module controller(
    input  [5:0] op, 
    input  [5:0] func,
    input  Z,
    output [1:0] pcsel,
    output [1:0] wasel, 
    output sext,
    output bsel,
    output [1:0] wdsel, 
    output reg [4:0] alufn,
    output wr,
    output werf, 
    output [1:0] asel
    );
   
    reg [9:0] controls;
    assign {werf, wdsel[1:0], wasel[1:0], asel[1:0], bsel, sext, wr} = controls[9:0];
    
    // Controls 4-way multiplexor
    assign pcsel = ((op == 6'b0) & (func == `JR)) ? 2'b11
                 : (op == `J || op == `JAL) ? 2'b10
                 : ((Z && op == `BEQ) || (~Z && op == `BNE)) ? 2'b01
                 : 2'b00;

    // Control Codes
    // ==============================================
    always_comb
    
        // non-R-type instructions
        case(op)
            `LW: controls <= 10'b1_10_01_00_1_1_0;     // LW   (DONE)
            `SW: controls <= 10'b0_01_01_00_1_1_1;     // SW   (DONE)
          `ADDI,                                       // ADDI (DONE)
          `SLTI,                                       // SLTI (DONE)
           `ORI: controls <= 10'b1_01_01_00_1_1_0;     // ORI  (DONE)
           `BEQ,                                       // BEQ  (DONE)
           `BNE: controls <= 10'b0_xx_xx_00_0_1_0;     // BNE  (DONE)
             `J: controls <= 10'b0_xx_xx_xx_x_x_0;     // J    (DONE)
           `JAL: controls <= 10'b1_00_10_xx_x_x_0;     // JAL  (DONE)
           `LUI: controls <= 10'b1_01_01_10_1_0_1;     // LUI  (DONE)
            
        // R-type    
      6'b000000:                                    
          case(func)
              `ADD,                                    // ADD  (DONE)
              `SUB,                                    // SUB  (DONE)
              `AND,                                    // AND  (DONE)
               `OR,                                    // OR   (DONE)
              `XOR,                                    // XOR  (DONE)
              `NOR,                                    // NOR  (DONE)
              `SLT,                                    // SLT  (DONE)
             `SLTU: controls <= 10'b1_01_00_00_0_x_0;  // SLTU (DONE)
              `SLL,                                    // SLL  (DONE)
              `SRL,                                    // SRL  (DONE)
              `SRA: controls <= 10'b1_01_00_01_0_x_0;  // SRA  (DONE)
             `SLLV: controls <= 10'b1_01_00_00_0_x_0;  // SLLV (DONE)
               `JR: controls <= 10'b0_xx_xx_xx_x_x_0;  // JR   (DONE)
               
           // unknown instruction, turn off register and memory writes
           default: controls <= 10'b0_00_00_00_0_0_0;  // ???  (DONE)
           
          endcase
          
        // unknown instruction, turn off register and memory writes
        default: controls <= 10'b0_00_00_00_0_0_0;     // ???  (DONE)
      
    endcase
    
    // ALUFN Codes
    // ==============================================
    always_comb
    
        // non-R-type instructions
        case(op)
            `LW,                           // LW   (DONE)
            `SW,                           // SW   (DONE)
          `ADDI: alufn <= 5'b0xx01;        // ADDI (DONE)
          `SLTI: alufn <= 5'b1x011;        // SLTI (DONE)
           `BEQ,                           // BEQ  (DONE) - Want to see if Z flag is 0
           `BNE: alufn <= 5'b1xx01;        // BNE  (DONE)
           `LUI: alufn <= 5'bx0010;        // LUI  (DONE)
    
        // R-type
      6'b000000:                      
          case(func)
               `ADD: alufn <= 5'b0xx01;    // ADD  (DONE)
               `SUB: alufn <= 5'b1xx01;    // SUB  (DONE)
               `AND: alufn <= 5'bx0000;    // AND  (DONE)
                `OR: alufn <= 5'bx0100;    // OR   (DONE)
               `XOR: alufn <= 5'bx1000;    // XOR  (DONE)
               `NOR: alufn <= 5'bx1100;    // NOR  (DONE)
               `SLT: alufn <= 5'b1x011;    // SLT  (DONE)
              `SLTU: alufn <= 5'b1x111;    // SLTU (DONE)
               `SLL,                       // SLL  (DONE)
              `SLLV: alufn <= 5'bx0010;    // SLLV (DONE)
               `SRL: alufn <= 5'bx1010;    // SRL  (DONE)
               `SRA: alufn <= 5'bx1110;    // SRA  (DONE)

            default: alufn <= 5'bxxxxx;    // ???  (DONE)
            
          endcase
        
        default: alufn <= 5'bxxxxx;        // ???  (DONE)
        
    endcase
    
endmodule