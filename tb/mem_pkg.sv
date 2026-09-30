package mem_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class mem_item extends uvm_sequence_item;
    rand bit we;
    rand bit [3:0] addr;
    rand bit [7:0] wdata;
    `uvm_object_utils(mem_item)
    function new(string name="mem_item"); super.new(name); endfunction
  endclass

  class mem_sample extends uvm_sequence_item;
    bit rst_n, req, we, rvalid;
    bit [3:0] addr;
    bit [7:0] wdata, rdata;
    `uvm_object_utils(mem_sample)
    function new(string name="mem_sample"); super.new(name); endfunction
  endclass

  class mem_sequencer extends uvm_sequencer #(mem_item);
    `uvm_component_utils(mem_sequencer)
    function new(string name, uvm_component parent); super.new(name,parent); endfunction
  endclass

  class mem_driver extends uvm_driver #(mem_item);
    `uvm_component_utils(mem_driver)
    virtual mem_if vif;
    function new(string name, uvm_component parent); super.new(name,parent); endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual mem_if)::get(this,"","vif",vif))
        `uvm_fatal("NOVIF","driver has no virtual interface")
    endfunction
    task run_phase(uvm_phase phase);
      vif.req = 0;
      forever begin
        seq_item_port.get_next_item(req);
        @(negedge vif.clk);
        vif.req = 1;
        vif.we = req.we;
        vif.addr = req.addr;
        vif.wdata = req.wdata;
        @(posedge vif.clk);
        seq_item_port.item_done();
        @(negedge vif.clk);
        vif.req = 0;
      end
    endtask
  endclass

  class mem_monitor extends uvm_monitor;
    `uvm_component_utils(mem_monitor)
    virtual mem_if vif;
    uvm_analysis_port #(mem_sample) ap;
    function new(string name, uvm_component parent); super.new(name,parent); endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual mem_if)::get(this,"","vif",vif))
        `uvm_fatal("NOVIF","monitor has no virtual interface")
      ap = new("ap",this);
    endfunction
    task run_phase(uvm_phase phase);
      mem_sample s;
      forever begin
        @(posedge vif.clk);
        s = mem_sample::type_id::create("s");
        s.rst_n = vif.rst_n;
        s.req = vif.req;
        s.we = vif.we;
        s.addr = vif.addr;
        s.wdata = vif.wdata;
        #1ps; // sample read result after DUT's nonblocking updates
        s.rvalid = vif.rvalid;
        s.rdata = vif.rdata;
        ap.write(s);
      end
    endtask
  endclass

  class mem_agent extends uvm_agent;
    `uvm_component_utils(mem_agent)
    mem_sequencer sqr;
    mem_driver drv;
    mem_monitor mon;
    function new(string name, uvm_component parent); super.new(name,parent); endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sqr = mem_sequencer::type_id::create("sqr",this);
      drv = mem_driver::type_id::create("drv",this);
      mon = mem_monitor::type_id::create("mon",this);
    endfunction
    function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
  endclass

  class mem_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(mem_scoreboard)
    uvm_analysis_imp #(mem_sample,mem_scoreboard) imp;
    bit [7:0] model [16];
    bit known [16];
    bit [7:0] last_rdata=0;
    int writes=0, reads=0, resets=0, checked_ops=0;
    function new(string name, uvm_component parent); super.new(name,parent); endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      imp = new("imp",this);
    endfunction
    function void write(mem_sample s);
      bit expected_valid;
      bit [7:0] expected_data;
      if (!s.rst_n) begin
        resets++;
        if (s.rvalid !== 0 || s.rdata !== 0)
          `uvm_error("RESET","read response not reset")
        last_rdata = 0;
        return; // reset does not erase memory contents
      end
      expected_valid = s.req && !s.we;
      if (s.rvalid !== expected_valid)
        `uvm_error("RVALID",$sformatf("addr=%0d req=%0b we=%0b expected=%0b got=%0b",s.addr,s.req,s.we,expected_valid,s.rvalid))
      if (!expected_valid && s.rdata !== last_rdata)
        `uvm_error("HOLD",$sformatf("read data changed without read: expected=%02h got=%02h",last_rdata,s.rdata))
      if (s.req) begin
        checked_ops++;
        if (s.we) begin
          model[s.addr] = s.wdata;
          known[s.addr] = 1;
          writes++;
        end else begin
          if (!known[s.addr])
            `uvm_fatal("TESTPLAN",$sformatf("read from unwritten addr %0d",s.addr))
          expected_data = model[s.addr];
          if (s.rdata !== expected_data)
            `uvm_error("RDATA",$sformatf("addr=%0d expected=%02h got=%02h",s.addr,expected_data,s.rdata))
          last_rdata = expected_data;
          reads++;
        end
      end
    endfunction
  endclass

  class mem_env extends uvm_env;
    `uvm_component_utils(mem_env)
    mem_agent agent;
    mem_scoreboard sb;
    function new(string name, uvm_component parent); super.new(name,parent); endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agent = mem_agent::type_id::create("agent",this);
      sb = mem_scoreboard::type_id::create("sb",this);
    endfunction
    function void connect_phase(uvm_phase phase);
      agent.mon.ap.connect(sb.imp);
    endfunction
  endclass

  class mem_sequence extends uvm_sequence #(mem_item);
    `uvm_object_utils(mem_sequence)
    int issued=0;
    function new(string name="mem_sequence"); super.new(name); endfunction
    task send(bit write_op, bit [3:0] a, bit [7:0] d=0);
      mem_item item;
      item = mem_item::type_id::create("item");
      start_item(item);
      item.we=write_op; item.addr=a; item.wdata=d;
      finish_item(item);
      issued++;
    endtask
    task body();
      // Initialize every location so random reads have a defined result.
      for (int a=0; a<16; a++) send(1,4'(a),8'(a*13+7));
      for (int a=0; a<16; a++) send(0,4'(a));
      send(1,0,8'hA5); send(0,0);
      send(1,15,8'h5A); send(0,15);
      for (int n=0; n<100; n++) begin
        bit [3:0] a;
        a = 4'($urandom_range(0,15));
        if ($urandom_range(0,1) == 1) send(1,a,8'($urandom));
        else send(0,a);
      end
    endtask
  endclass

  class mem_probe_sequence extends mem_sequence;
    `uvm_object_utils(mem_probe_sequence)
    function new(string name="mem_probe_sequence"); super.new(name); endfunction
    task body();
      send(0,0);
      send(0,15);
    endtask
  endclass

  class mem_test extends uvm_test;
    `uvm_component_utils(mem_test)
    mem_env env;
    virtual mem_if vif;
    function new(string name, uvm_component parent); super.new(name,parent); endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = mem_env::type_id::create("env",this);
      if (!uvm_config_db#(virtual mem_if)::get(this,"","vif",vif))
        `uvm_fatal("NOVIF","test has no virtual interface")
    endfunction
    task run_phase(uvm_phase phase);
      mem_sequence seq;
      mem_probe_sequence probe;
      int expected_ops;
      phase.raise_objection(this);
      // Hold reset across clock edges, then release away from the active edge.
      vif.rst_n=0;
      repeat (3) @(negedge vif.clk);
      vif.rst_n=1;
      seq=mem_sequence::type_id::create("seq");
      seq.start(env.agent.sqr);
      wait (env.sb.checked_ops == seq.issued);
      expected_ops = seq.issued;
      // Reset clears the response, but must preserve the written memory.
      @(negedge vif.clk);
      vif.rst_n=0;
      // Let the driver return to idle before the direct reset probe.
      @(negedge vif.clk);
      // An attempted write while reset is active must be ignored.
      vif.req=1;
      vif.we=1;
      vif.addr=0;
      vif.wdata=8'hFF;
      @(negedge vif.clk);
      vif.req=0;
      vif.rst_n=1;
      probe=mem_probe_sequence::type_id::create("probe");
      probe.start(env.agent.sqr);
      expected_ops += probe.issued;
      wait (env.sb.checked_ops == expected_ops);
      repeat (2) @(negedge vif.clk);
      if (env.sb.writes==0 || env.sb.reads==0 || env.sb.resets<5 || env.sb.checked_ops!=expected_ops)
        `uvm_fatal("EMPTY","required operation class was not observed")
      `uvm_info("RESULT",$sformatf("PASS: writes=%0d reads=%0d resets=%0d checked_ops=%0d",env.sb.writes,env.sb.reads,env.sb.resets,env.sb.checked_ops),UVM_NONE)
      phase.drop_objection(this);
    endtask
  endclass
endpackage
