`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 16:31:59
// Design Name: 
// Module Name: packet
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

//includes all inputs and outputs of the dut that can be randomised 
//note dout is not randomised 
class packet #(parameter addr_width = 8, data_width = 16, depth = 256 );//imp end of class we have semicolon
    rand bit we_A,we_B,re_A,re_B;
    rand logic [addr_width-1:0] addr_A, addr_B;
    rand logic [data_width-1:0] datain_A, datain_B;

    //display function 
    function void display(string name);//remember 
        $display("-----------------------------------");
        $display("%s",name);
        $display("-----------------------------------");
        $display("we_A=%0d, we_B=%0d, re_A=%0d, re_B=%0d, addr_A=%0h, addr_B=%0h, datain_A=%0h, datain_B=%0h",$time,we_A,we_B,re_A,re_B,addr_A,addr_B,datain_A,datain_B);
        $display("-----------------------------------");
    endfunction
endclass    

    


