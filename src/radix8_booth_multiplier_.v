`timescale 1ns / 1ps
module compressor_5_3(input a,b,c,d,e, output sum,carry1,carry2);
    wire s1,c1,s2,c2,t1,t2,t3,u1,u2,u3;
    xor(s1,a,b,c);                 // first stage XOR
    and(t1,a,b);
    and(t2,b,c);
    and(t3,c,a);
    or(c1,t1,t2,t3);               // first carry
    xor(s2,s1,d,e);                // second stage XOR
    and(u1,s1,d);
    and(u2,d,e);
    and(u3,e,s1);
    or(c2,u1,u2,u3);               // second carry
    assign sum    = s2;
    assign carry1 = c1;
    assign carry2 = c2;
endmodule

module radix8_booth_multiplier(
    input  signed [7:0]  A,
    input  signed [7:0]  B,
    output signed [15:0] P
);
   
    // We sign-extend MSB and add a single 0 LSB to create proper overlapping groups.
    wire [10:0] B_ext = {B[7], B[7], B, 1'b0};

    wire [3:0] g0 = B_ext[3:0];
    wire [3:0] g1 = B_ext[6:3];
    wire [3:0] g2 = B_ext[9:6];

    // Booth Decode Function (Behavioral) 
    function signed [15:0] booth_decode;
        input signed [7:0] m;
        input [3:0] bits;
        begin
            case (bits)
                4'b0000, 4'b1111: booth_decode = 16'sd0;                                           //  0
                4'b0001, 4'b0010: booth_decode = {{8{m[7]}}, m};                                    // +1 * A
                4'b0011, 4'b0100: booth_decode = {{8{m[7]}}, m} <<< 1;                              // +2 * A
                4'b0101, 4'b0110: booth_decode = ({{8{m[7]}}, m} <<< 1) + {{8{m[7]}}, m};          // +3 * A
                4'b0111:           booth_decode = {{8{m[7]}}, m} <<< 2;                              // +4 * A
                4'b1000:           booth_decode = -({{8{m[7]}}, m} <<< 2);                           // -4 * A
                4'b1001, 4'b1010: booth_decode = -(({{8{m[7]}}, m} <<< 1) + {{8{m[7]}}, m});        // -3 * A
                4'b1011, 4'b1100: booth_decode = -({{8{m[7]}}, m} <<< 1);                           // -2 * A
                4'b1101, 4'b1110: booth_decode = -({{8{m[7]}}, m});                                 // -1 * A
                default:          booth_decode = 16'sd0;
            endcase
        end
    endfunction

    // Generate Partial Products (signed 16-bit)
    wire signed [15:0] pp0 = booth_decode(A, g0);        // group 0, no shift
    wire signed [15:0] pp1 = booth_decode(A, g1) <<< 3;  // group 1, shift by 3
    wire signed [15:0] pp2 = booth_decode(A, g2) <<< 6;  // group 2, shift by 6

    // Final addition
    assign P = pp0 + pp1 + pp2;
endmodule
