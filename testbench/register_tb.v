module router_reg_tb();
    reg clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,lfd_state;
    reg [7:0]data_in;
    wire parity_done,low_pkt_valid,err;
    wire [7:0]dout;

router_reg dut(

.clock(clock),
.resetn(resetn),
.pkt_valid(pkt_valid),
.fifo_full(fifo_full),
.rst_int_reg(rest_int_reg),
.detect_add(detect_add),
.ld_state(ld_state),
.laf_state(laf_state),
.lfd_state(lfd_state),
.data_in(data_in),

.parity_done(parity_done),
.low_pkt_valid(low_pkt_valid),
.err(err),
.dout(dout)

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
    pkt_valid=1'b0;
    fifo_full=1'b0;
    rst_int_reg=1'b0;
    detect_add=1'b0;
    ld_state=1'b0;
    laf_state=1'b0;
    lfd_state=1'b0;
    data_in=8'b0;
end
endtask

task header(input[7:0]data);
begin
    data_in=data;
    detect_add = 1'b1;
    pkt_valid = 1'b1;
    @(posedge clock);
    detect_add=1'b0;
end
endtask

task h_to_fifo; 
begin
    lfd_state =1'b1;
    pkt_valid =1'b1;
    fifo_full =1'b0;
    @(posedge clock);
    lfd_state =1'b0;
end
endtask

task payload(input [7:0]data);
begin
    data_in=data;
    ld_state  =1'b1;
    pkt_valid =1'b1;
    fifo_full =1'b0;
    @(posedge clock);
    ld_state  =1'b0;
end
endtask

task parity(input [7:0]data);
begin
    data_in=data;
    ld_state =1'b1;
    pkt_valid =1'b0;
    fifo_full =1'b0;
    @(posedge clock);
    ld_state  =1'b0;
end
endtask

task full(input [7:0]data);
begin
    data_in=data;
    ld_state =1'b1;
    pkt_valid =1'b1;
    fifo_full =1'b1;
    @(posedge clock);
    fifo_full =1'b0;
    ld_state =1'b0;
end
endtask

task laf_l;
begin
    laf_state=1'b1;
    @(posedge clock);
    laf_state = 0;
end
endtask

initial
begin
//test1
    init;
    rst;
    header(8'h10);
    h_to_fifo;
    payload(8'hAA);
    payload(8'h55);
    payload(8'hF0);
    payload(8'h0F);
    parity(8'h10);
    @(posedge clock);
    rst_int_reg=1;
    @(posedge clock);
    rst_int_reg=0;
//test2
    header(8'h0D);  
    h_to_fifo;  
    payload(8'h12);
    payload(8'h34);
    payload(8'h56);
    parity(8'h7C);
    @(posedge clock);
    rst_int_reg=1;
    @(posedge clock);
    rst_int_reg=0;
//test3
    init;
    rst;
    header(8'h0D);
    h_to_fifo;
    payload(8'h12);
    payload(8'h34);
    full(8'h56);
    repeat(5)begin
    @(posedge clock);
    end
    laf_l;
    parity(8'h7D);
    @(posedge clock);
    rst_int_reg=1;
    @(posedge clock);
    rst_int_reg=0;

    #1000 $finish;
end

initial
begin
    $monitor(
        "T=%0t data=%h dout=%h pkt_valid=%b ld=%b lfd=%b laf=%b parity_done=%b low_pkt=%b err=%b",
        $time,
        data_in,
        dout,
        pkt_valid,
        ld_state,
        lfd_state,
        laf_state,
        parity_done,
        low_pkt_valid,
        err
    );
end
endmodule
