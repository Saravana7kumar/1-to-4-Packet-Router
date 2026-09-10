module router (
    input clk,
    input rst_n,
    input in_valid,
    input [9:0] in_data,
    output in_ready,
    output out0_valid,
    output [7:0] out0_data,
    input out0_ready,
    output out1_valid,
    output [7:0] out1_data,
    input out1_ready,
    output out2_valid,
    output [7:0] out2_data,
    input out2_ready,
    output out3_valid,
    output [7:0] out3_data,
    input out3_ready
);

    wire [1:0] dest = in_data[9:8];
    wire [7:0] payload = in_data[7:0];
    wire sel0 = (dest == 2'd0);
    wire sel1 = (dest == 2'd1);
    wire sel2 = (dest == 2'd2);
    wire sel3 = (dest == 2'd3);
    assign out0_valid = in_valid && sel0;
    assign out1_valid = in_valid && sel1;
    assign out2_valid = in_valid && sel2;
    assign out3_valid = in_valid && sel3;
    assign out0_data = payload;
    assign out1_data = payload;
    assign out2_data = payload;
    assign out3_data = payload;
    assign in_ready = (sel0 && out0_ready) || (sel1 && out1_ready) ||(sel2 && out2_ready) || (sel3 && out3_ready);
endmodule