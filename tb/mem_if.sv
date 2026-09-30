`timescale 1ns/1ps
interface mem_if(input logic clk);
  logic rst_n=0, req=0, we=0;
  logic [3:0] addr=0;
  logic [7:0] wdata=0;
  logic rvalid;
  logic [7:0] rdata;
endinterface
