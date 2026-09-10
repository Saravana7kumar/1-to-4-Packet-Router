`timescale 1ns/1ps

module router_tb;
    reg clk, rst_n;
    reg in_valid;
    reg [9:0] in_data;
    wire in_ready;
    wire out0_valid, out1_valid, out2_valid, out3_valid;
    wire [7:0] out0_data, out1_data, out2_data, out3_data;
    reg out0_ready, out1_ready, out2_ready, out3_ready;
    router dut (
        .clk(clk), .rst_n(rst_n),
        .in_valid(in_valid), .in_data(in_data), .in_ready(in_ready),
        .out0_valid(out0_valid), .out0_data(out0_data), .out0_ready(out0_ready),
        .out1_valid(out1_valid), .out1_data(out1_data), .out1_ready(out1_ready),
        .out2_valid(out2_valid), .out2_data(out2_data), .out2_ready(out2_ready),
        .out3_valid(out3_valid), .out3_data(out3_data), .out3_ready(out3_ready)
    );

    always #5 clk = ~clk;
    task send_pkt(input [1:0] dest, input [7:0] data);
        begin
            @(posedge clk);
            in_valid <= 1;
            in_data  <= {dest, data};
            @(posedge clk);
            while (!in_ready) @(posedge clk);
            in_valid <= 0;
        end
    endtask

    initial begin
        clk   = 0;
        rst_n = 0;
        in_valid = 0;
        in_data  = 0;
        out0_ready = 1;
        out1_ready = 1;
        out2_ready = 1;
        out3_ready = 1;
        #20 rst_n = 1;
        @(posedge clk);
        send_pkt(2'd0, 8'hAA);
        send_pkt(2'd1, 8'hBB);
        send_pkt(2'd2, 8'hCC);
        send_pkt(2'd3, 8'hDD);
        send_pkt(2'd1, 8'h11);
        out2_ready = 0;
        @(posedge clk);
        in_valid <= 1;
        in_data  <= {2'd2, 8'hEE};
        $display("T=%0t sending to port2 while out2_ready=0, in_ready=%0d (should be 0)", $time, in_ready);
        repeat (3) @(posedge clk);
        $display("T=%0t releasing out2_ready", $time);
        out2_ready = 1;
        @(posedge clk);
        while (!in_ready) @(posedge clk);
        in_valid <= 0;
        #20;
        $display("done");
        $finish;
    end
    always @(posedge clk) begin
        if (out0_valid && out0_ready) $display("T=%0t PORT0 got data=0x%0h", $time, out0_data);
        if (out1_valid && out1_ready) $display("T=%0t PORT1 got data=0x%0h", $time, out1_data);
        if (out2_valid && out2_ready) $display("T=%0t PORT2 got data=0x%0h", $time, out2_data);
        if (out3_valid && out3_ready) $display("T=%0t PORT3 got data=0x%0h", $time, out3_data);
    end

endmodule