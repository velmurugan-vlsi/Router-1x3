module router_sync_tb;
reg detect_add,write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
reg[1:0]data_in;
wire vld_out_0,vld_out_1,vld_out_2;
wire soft_reset_0,soft_reset_1,soft_reset_2,fifo_full;
wire [2:0]write_enb;

router_sync DUT(
.detect_add(detect_add),
.write_enb_reg(write_enb_reg),
.clock(clock),
.resetn(resetn),

.read_enb_0(read_enb_0),
.read_enb_1(read_enb_1),
.read_enb_2(read_enb_2),

.empty_0(empty_0),
.empty_1(empty_1),
.empty_2(empty_2),

.full_0(full_0),
.full_1(full_1),
.full_2(full_2),

.data_in(data_in),

.vld_out_0(vld_out_0),
.vld_out_1(vld_out_1),
.vld_out_2(vld_out_2),

.soft_reset_0(soft_reset_0),
.soft_reset_1(soft_reset_1),
.soft_reset_2(soft_reset_2),

.write_enb(write_enb),
.fifo_full(fifo_full)
);

initial
begin
    clock=0;
    forever #5 clock=~clock;
end

task initialize;
begin
    {read_enb_0,read_enb_1,read_enb_2}=3'b000;
    {empty_0,empty_1,empty_2}=3'b111;
    {full_0,full_1,full_2}=3'b000;
end
endtask

task reset;
begin
    resetn=0;
    @(posedge clock);
    resetn=1;
end
endtask

task write_enb_reg_t;
begin
    write_enb_reg = 1;
    @(posedge clock);
    write_enb_reg = 0;
end
endtask

task read_enb_t;
    begin
        read_enb_2=1;
        @(posedge clock);
        read_enb_2=0;
    end
endtask
task add;
input [1:0]data;
begin
    data_in=data;
    detect_add=1;
    @(posedge clock);
    detect_add=0;
end
endtask

task full;
begin
    full_1=1;
end
endtask

initial
begin
    initialize;
    reset;

    add(2'b01);     //test 1
    write_enb_reg_t;
    empty_1=0;
    full;

    repeat(31)begin
    @(posedge clock);
    end 

    initialize;
    @(posedge clock);
    reset;
    add(2'b11);             //test 2
    write_enb_reg_t;
    empty_2=0;
    read_enb_t;

    #1000 $finish;
end

initial
begin
    $monitor("resetn=%b detect_add=%b write_enb_reg=%b write_enb=%b read_enb_0=%b read_enb_1=%b read_enb_2=%b empty_0=%b empty_1=%b empty_2=%b full_0=%b full_1=%b full_2=%b data_in=%b vld_out_0=%b vld_out_1=%b vld_out_2=%b soft_reset_0=%b soft_reset_1=%b soft_reset_2=%b fifo_full=%b ",
              resetn,detect_add,write_enb_reg,write_enb,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,data_in,vld_out_0,vld_out_1,vld_out_2,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full);
end

endmodule
