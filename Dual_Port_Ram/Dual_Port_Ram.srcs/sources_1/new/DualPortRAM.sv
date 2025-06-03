`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.12.2024 20:29:59
// Design Name: 
// Module Name: DualPortRAM
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


module DualPortRAM #(parameter addr_width = 8, data_width = 16, depth = 256 ) // Memory depth
(
    input logic clk,
    input logic we_A, we_B,
    input logic re_A, re_B,
    input logic [addr_width-1:0] addr_A, addr_B,
    input logic [data_width-1:0] datain_A, datain_B,
    output logic [data_width-1:0] dataout_A, dataout_B
        );
        //creating the 2D array for memory 
        //logic [data_width-1:0] data_mem [addr_width-1:0]; CORRECTION
        logic [data_width-1:0] data_mem [0:depth-1];
    
    //individual operations of the ports     
    
    //port A write operation followed by read operation 
    /*all conditions 
    1) write operation
    - address of A should be valid
    - we of A is high, re of A is low
    -we are also making sure to avoid simultanous write operation into the port 
        as the value stored may be unpredictable / udefined
    
    2) read operation
    -address A shoud be valid and UNIQUE
    -re of A is high , we of A is low
    -for out of bound address , output is undefined 
    */    
    always @ (posedge clk) 
    begin    
    //check if valid address 
    //define a variable addr as input logic 
        if (addr_A < depth)
        //port A write operation
        begin
            if(we_A && (!we_B || addr_A != addr_B))
            begin
             data_mem[addr_A] <= datain_A;
            end 
        //port A read operation
            if(re_A)
            begin
            dataout_A <= data_mem[addr_A];
            end 
        end 
        else 
            begin
            // Out-of-bounds address: Output is undefined
            dataout_A <= 'x;
            end
     end 
     
    always @ (posedge clk) 
    begin    
    //check if valid address 
    //define a variable addr as input logic 
        if (addr_B < depth)
        //port B write operation
        begin
            if(we_B && (!we_A || addr_B != addr_A))
            begin
             data_mem[addr_B] <= datain_B;
            end 
        //port B read operation
            if(re_B)
            begin
            dataout_B <= data_mem[addr_B];
            end 
        end 
        else begin
            // Out-of-bounds address: Output is undefined
            dataout_B <= 'x;
        end
     end    
endmodule          
