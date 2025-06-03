module dual_port_ram #(
    parameter ADDR_WIDTH = 8,   // Address width
    parameter DATA_WIDTH = 16,  // Data width
    parameter DEPTH = 256       // Memory depth
) (
    input logic clk,            // Clock signal
    input logic we_A, we_B,     // Write enable for ports A and B
    input logic re_A, re_B,     // Read enable for ports A and B
    input logic [ADDR_WIDTH-1:0] addr_A, addr_B, // Addresses
    input logic [DATA_WIDTH-1:0] data_in_A, data_in_B, // Data inputs
    output logic [DATA_WIDTH-1:0] data_out_A, data_out_B // Data outputs
);

    // Memory array
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Documentation: Expected behavior for edge cases
    // 1. Simultaneous writes to the same address:
    //    - Write by Port A is prioritized over Port B.
    // 2. Simultaneous read and write to the same address on the same port:
    //    - Data written in the same cycle is immediately visible for the read operation.
    // 3. Out-of-bounds address access:
    //    - No memory operation is performed; outputs are undefined.
    // 4. No-operation conditions (both `we` and `re` low):
    //    - The memory remains idle with no changes to outputs or contents.

    // Address validation function
    function logic is_valid_addr(input logic [ADDR_WIDTH-1:0] addr);
        return (addr < DEPTH); // Address must be within valid range
    endfunction

    // Port A: Read/Write logic
    always_ff @(posedge clk) begin
        if (is_valid_addr(addr_A)) begin
            if (we_A && (!we_B || addr_A != addr_B)) begin
                // Write to Port A (prioritized over Port B if addresses conflict)
                mem[addr_A] <= data_in_A;
            end
            if (re_A) begin
                // Read from Port A
                data_out_A <= mem[addr_A];
            end
        end else begin
            // Out-of-bounds address: Output is undefined
            data_out_A <= 'x;
        end
    end

    // Port B: Read/Write logic
    always_ff @(posedge clk) begin
        if (is_valid_addr(addr_B)) begin
            if (we_B && (!we_A || addr_A != addr_B)) begin
                // Write to Port B (if not conflicting with Port A)
                mem[addr_B] <= data_in_B;
            end
            if (re_B) begin
                // Read from Port B
                data_out_B <= mem[addr_B];
            end
        end else begin
            // Out-of-bounds address: Output is undefined
            data_out_B <= 'x;
        end
    end

endmodule
