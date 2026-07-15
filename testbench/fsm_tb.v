module fsm_tb ();
    reg resetn,clock,pkt_valid,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full;
    reg [1:0] data_in;
    reg parity_done;
    wire ld_state,busy,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,detect_add;

fsm DUT(

.resetn(resetn),
.clock(clock),

.pkt_valid(pkt_valid),
.low_pkt_valid(low_pkt_valid),

.fifo_empty_0(fifo_empty_0),
.fifo_empty_1(fifo_empty_1),
.fifo_empty_2(fifo_empty_2),

.soft_reset_0(soft_reset_0),
.soft_reset_1(soft_reset_1),
.soft_reset_2(soft_reset_2),

.fifo_full(fifo_full),

.data_in(data_in),

.parity_done(parity_done),

.ld_state(ld_state),
.busy(busy),
.laf_state(laf_state),
.full_state(full_state),
.write_enb_reg(write_enb_reg),
.rst_int_reg(rst_int_reg),
.lfd_state(lfd_state),
.detect_add(detect_add)

);


initial
begin
    clock=0;
    forever #5 clock=~clock;
end

task rst;
begin
    @(negedge clock);
    resetn=0;
    @(negedge clock);
    resetn=1;
end
endtask

task init;
begin
    pkt_valid     = 0;
    low_pkt_valid = 0;
    fifo_empty_0  = 0;
    fifo_empty_1  = 0;
    fifo_empty_2  = 0;
    soft_reset_0  = 0;
    soft_reset_1  = 0;
    soft_reset_2  = 0;
    fifo_full     = 0;
    parity_done   = 0;
    data_in       = 0;
end
endtask

task data_in_t;
input [1:0]data;
begin
    data_in=data;
end
endtask

initial
begin
    //test1
//decode->lfd
    init;
    rst;
    @(posedge clock);
    pkt_valid=1;
    data_in_t(2'b00);
    fifo_empty_0=1;
    @(posedge clock);
//lfd->ld
   @(posedge clock);
//ld->ld_parity
    fifo_full=0;
    pkt_valid=0;
    @(posedge clock);
    fifo_full=0;

    //test2
//decode->lfd
    init;
    rst;
    @(posedge clock);
    pkt_valid=1;
    data_in_t(2'b01);
    fifo_empty_1=1;
    @(posedge clock);
//lfd->ld
    @(posedge clock);
//ld->full
    fifo_full=1;
    repeat(5)begin
    @(posedge clock);
    end
    fifo_full=0;
    @(posedge clock);
//full->laf
    low_pkt_valid=1;
    parity_done=0;
    @(posedge clock);
//laf->check
    fifo_full=0;


   //test3
//decode->wait
   init;
   rst;
   @(posedge clock);
   pkt_valid=1;
   data_in_t(2'b10);
   fifo_empty_2=0;
    @(posedge clock);
   fifo_empty_2=1;
   @(posedge clock);

   #1000 $finish;
end

initial
begin
    $monitor("resetn=%B pkt_valid=%b low_pkt_valid=%b fifo_empty_0=%b fifo_empty_1=%b fifo_empty_2=%b soft_reset_0=%b soft_reset_1=%b soft_reset_2=%b fifo_full=%b data_in=%b ld_state=%b busy=%b laf_state=%b full_state=%B write_enb_reg=%b rst_int_reg=%b lfd_state=%b detect_add=%b ",
              resetn,pkt_valid,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,data_in,ld_state,busy,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,detect_add);
end

endmodule
