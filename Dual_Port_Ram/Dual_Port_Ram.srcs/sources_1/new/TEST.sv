`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 12:52:52
// Design Name: 
// Module Name: TEST
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TEST #(

    parameter ADDR_WIDTH = 8,   // Address width
    parameter DATA_WIDTH = 16,  // Data width
    parameter DEPTH = 256       // Memory depth
) (
    input logic clk,            // Clock signal
    input logic we_A, we_B,     // Write enable for ports A and B
    input logic re_A, re_B,     // Read enable for ports A and B
    input logic [ADDR_WIDTH-1:0] addr_A, addr_B, // Addresses
    input logic [DATA_WIDTH-1:0] datain_A, datain_B, // Data inputs
    output logic [DATA_WIDTH-1:0] dataout_A, dataout_B // Data outputs
);

    // Memory array
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Address validation function
    function logic is_valid_addr(input logic [ADDR_WIDTH-1:0] addr);
        return (addr < DEPTH); // Address must be within valid range
    endfunction

    // Port A Logic
    always_ff @(posedge clk) begin
        if (is_valid_addr(addr_A)) begin
            // Write Operation
            if (we_A && (!we_B || addr_A != addr_B)) begin
                mem[addr_A] <= datain_A;
            end
            // Read Operation
            if (re_A) begin
                dataout_A <= mem[addr_A];
            end
        end else begin
            // Out-of-bounds address: Output is undefined
            dataout_A <= 'x;
        end
    end

    // Port B Logic
    always_ff @(posedge clk) begin
        if (is_valid_addr(addr_B)) begin
            // Write Operation
            if (we_B && (!we_A || addr_A != addr_B)) begin
                mem[addr_B] <= datain_B;
            end
            // Read Operation
            if (re_B) begin
                dataout_B <= mem[addr_B];
            end
        end else begin
            // Out-of-bounds address: Output is undefined
            dataout_B <= 'x;
        end
    end

endmodule
