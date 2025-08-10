module tb_async_fifo;

  parameter ADDR  = 4;
  parameter WIDTH = 8;

  // Stimulus and Internal Variable
  reg                wr_clk, rd_clk;
  reg                wr_rst_n, rd_rst_n;
  reg                wr_en, rd_en;
  reg  [WIDTH-1:0]   wr_data;
  wire [WIDTH-1:0]   rd_data;
  wire               full, empty;

  // Clock period variables (will be adjusted for modes)
  real wr_clk_period;
  real rd_clk_period;

  // Instantiate DUT
 FIFO_Top #(ADDR, WIDTH) dut (
    wr_clk,
    rd_clk,
    wr_rst_n,
    rd_rst_n,
    wr_en,
    rd_en,
    wr_data,
    rd_data,
    full,
    empty
  );

  //--------------------------
  // Clock Generation
  //--------------------------
  initial begin
    wr_clk = 0;
    forever #(wr_clk_period/2) wr_clk = ~wr_clk;
  end

  initial begin
    rd_clk = 0;
    forever #(rd_clk_period/2) rd_clk = ~rd_clk;
  end

  //--------------------------
  // Reset Task
  //--------------------------
  task reset_fifo;
  begin
    wr_rst_n = 0;
    rd_rst_n = 0;
    wr_en    = 0;
    rd_en    = 0;
    wr_data  = 0;
    #(5*wr_clk_period);
    #(5*rd_clk_period);
    wr_rst_n = 1;
    rd_rst_n = 1;
    $display("[%0t] Reset complete",$time);
  end
  endtask

  //--------------------------
  // Task: Write till full
  //--------------------------
  task write_till_full;
  integer count;
  begin
    $display("[%0t] Starting WRITE till FULL",$time);
    count = 0;
    while (!full) begin
      @(posedge wr_clk);
      wr_en   = 1;
      wr_data = $random;
      count = count + 1;
    end
    @(posedge wr_clk);
    wr_en = 0;
    $display("[%0t] FIFO FULL after %0d writes",$time,count);
  end
  endtask

  //--------------------------
  // Task: Read till empty
  //--------------------------
  task read_till_empty;
  integer count;
  begin
    $display("[%0t] Starting READ till EMPTY",$time);
    count = 0;
    while (!empty) begin
      @(posedge rd_clk);
      rd_en = 1;
      count = count + 1;
    end
    @(posedge rd_clk);
    rd_en = 0;
    $display("[%0t] FIFO EMPTY after %0d reads",$time,count);
  end
  endtask

  //--------------------------
  // Task: Simultaneous Read & Write
  //--------------------------
  task read_write_mix;
  integer cycles;
  begin
    $display("[%0t] Starting simultaneous READ/WRITE",$time);
    cycles = 0;
    repeat (100) begin
      @(posedge wr_clk);
      wr_en   = !full;
      wr_data = $random;
      @(posedge rd_clk);
      rd_en   = !empty;
      cycles = cycles + 1;
    end
    wr_en = 0;
    rd_en = 0;
    $display("[%0t] Completed mixed READ/WRITE cycles=%0d",$time,cycles);
  end
  endtask

  task run_scenario(input real wr_period, rd_period,
                    input phase_shift);
  begin
    $display("==================================================");
    wr_clk_period = wr_period;
    rd_clk_period = rd_period;
    
    if (phase_shift) begin
      rd_clk = 0;
      #(rd_clk_period/4); // Quarter cycle offset
    end else begin
      rd_clk = 0;
    end

    reset_fifo;
    write_till_full;
    read_till_empty;
    write_till_full;
    read_write_mix;
    read_till_empty;
  end
  endtask

  initial begin
    //Fast write -> Slow read
    run_scenario(5, 15, 0);

    //Slow write -> Fast read
    run_scenario(15, 5, 0);

    //Same frequency, phase difference
    run_scenario(10, 10, 1);

    //Same frequency, same phase
    run_scenario(10, 10, 0);
    $finish;
  end
    
endmodule