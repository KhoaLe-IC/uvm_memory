`timescale 1ns/1ps
module sync_memory #(parameter int ADDR_W=4, DATA_W=8) (
  input logic clk, rst_n, req, we,
  input logic [ADDR_W-1:0] addr,
  input logic [DATA_W-1:0] wdata,
  output logic rvalid,
  output logic [DATA_W-1:0] rdata
);
  logic [DATA_W-1:0] mem [0:(1<<ADDR_W)-1];
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      rvalid <= 1'b0;
      rdata <= '0;
    end else begin
      rvalid <= req && !we;
      if (req) begin
        if (we) mem[addr] <= wdata;
        else    rdata <= mem[addr];
      end
    end
  end
endmodule
