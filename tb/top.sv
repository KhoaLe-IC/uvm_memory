`timescale 1ns/1ps
module top;
  import uvm_pkg::*;
  import mem_pkg::*;
  logic clk=0;
  always #5ns clk=~clk;
  mem_if mif(clk);
  sync_memory dut(.clk(clk),.rst_n(mif.rst_n),.req(mif.req),.we(mif.we),
                  .addr(mif.addr),.wdata(mif.wdata),.rvalid(mif.rvalid),.rdata(mif.rdata));
  initial begin
    uvm_config_db#(virtual mem_if)::set(null,"uvm_test_top*","vif",mif);
    run_test("mem_test");
  end
  initial begin
    #100us;
    $fatal(1,"watchdog timeout");
  end
endmodule
