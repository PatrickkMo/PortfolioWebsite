/*
   This file was generated automatically by Alchitry Labs version 1.2.7.
   Do not edit this file directly. Instead edit the original Lucid source.
   This is a temporary file and any changes made to it will be destroyed.
*/

module au_top_0 (
    input clk,
    input rst_n,
    output reg [7:0] led,
    input usb_rx,
    output reg usb_tx,
    output reg [23:0] io_led,
    output reg [7:0] io_seg,
    output reg [3:0] io_sel,
    input [4:0] io_button,
    input [23:0] io_dip
  );
  
  
  
  reg rst;
  
  reg state_change;
  
  reg start_auto_test;
  
  wire [1-1:0] M_reset_cond_out;
  reg [1-1:0] M_reset_cond_in;
  reset_conditioner_1 reset_cond (
    .clk(clk),
    .in(M_reset_cond_in),
    .out(M_reset_cond_out)
  );
  wire [1-1:0] M_button_cond_out;
  reg [1-1:0] M_button_cond_in;
  button_conditioner_2 button_cond (
    .clk(clk),
    .in(M_button_cond_in),
    .out(M_button_cond_out)
  );
  wire [1-1:0] M_edge_out;
  reg [1-1:0] M_edge_in;
  edge_detector_3 L_edge (
    .clk(clk),
    .in(M_edge_in),
    .out(M_edge_out)
  );
  localparam MANUAL_state = 1'd0;
  localparam AUTOMATIC_state = 1'd1;
  
  reg M_state_d, M_state_q = MANUAL_state;
  wire [8-1:0] M_auto_tester_io_seg;
  wire [4-1:0] M_auto_tester_io_sel;
  wire [6-1:0] M_auto_tester_opcode_led;
  auto_tester_4 auto_tester (
    .clk(clk),
    .rst(rst),
    .start(start_auto_test),
    .error(io_button[0+0-:1]),
    .io_seg(M_auto_tester_io_seg),
    .io_sel(M_auto_tester_io_sel),
    .opcode_led(M_auto_tester_opcode_led)
  );
  wire [8-1:0] M_manual_tester_io_seg;
  wire [4-1:0] M_manual_tester_io_sel;
  wire [24-1:0] M_manual_tester_io_led;
  manual_tester_5 manual_tester (
    .clk(clk),
    .rst(rst),
    .io_dip(io_dip),
    .state_change_btn(io_button[1+0-:1]),
    .forced_error(io_button[0+0-:1]),
    .io_seg(M_manual_tester_io_seg),
    .io_sel(M_manual_tester_io_sel),
    .io_led(M_manual_tester_io_led)
  );
  
  always @* begin
    M_state_d = M_state_q;
    
    M_reset_cond_in = ~rst_n;
    rst = M_reset_cond_out;
    usb_tx = usb_rx;
    M_button_cond_in = io_button[2+0-:1];
    M_edge_in = M_button_cond_out;
    state_change = M_edge_out;
    start_auto_test = 1'h0;
    io_led = 24'h000000;
    io_seg = M_manual_tester_io_seg;
    io_sel = M_manual_tester_io_sel;
    
    case (M_state_q)
      MANUAL_state: begin
        io_led = M_manual_tester_io_led;
        if (state_change) begin
          M_state_d = AUTOMATIC_state;
        end
      end
      AUTOMATIC_state: begin
        io_seg = M_auto_tester_io_seg;
        io_sel = M_auto_tester_io_sel;
        io_led[16+0+5-:6] = M_auto_tester_opcode_led;
        start_auto_test = 1'h1;
        if (state_change) begin
          M_state_d = MANUAL_state;
        end
      end
    endcase
    led = 8'h00;
  end
  
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      M_state_q <= 1'h0;
    end else begin
      M_state_q <= M_state_d;
    end
  end
  
endmodule
