module  fifo_tb;
    reg resetn,clock,soft_reset,lfd_state,write_enb,read_enb;
    reg [7:0]data_in;
    wire [7:0]data_out;
    wire full,empty;

fifo uut(
        .resetn(resetn),
        .clock(clock),
        .soft_reset(soft_reset),
        .lfd_state(lfd_state),
        .write_enb(write_enb),
        .read_enb(read_enb),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
);


initial begin
    clock=1'b0;
    forever #5 clock=~clock;
end

task resetn_t;
begin
    resetn=0;
    @(posedge clock);
    resetn=1;
end
endtask


task soft_reset_t;
begin
    soft_reset=1;
    @(posedge clock);
    soft_reset=0;
end
endtask


task write_enb_t;
begin
    write_enb=1;
end
endtask

task w_off;
begin
    write_enb=0;
end
endtask

task read_t;
begin
    read_enb=1;
    repeat(18)
    begin
    @(posedge clock);
    end
    read_enb=0;
end
endtask


task header;
input lfd_state_t;
input [7:0]data;
begin
    lfd_state=lfd_state_t;
    data_in=data;
end
endtask

task payload;
input lfd_state_t;
input [7:0]data;
begin
    lfd_state=lfd_state_t;
    data_in=data;
end
endtask


initial
begin
    resetn_t;
    write_enb_t;
    header(1'b1,8'b00111110);
    @(posedge clock);
    payload(1'b0,8'hAB);
    @(posedge clock);
    payload(1'b0,8'hBA);
    @(posedge clock);
    payload(1'b0,8'hCD);
    @(posedge clock);
    payload(1'b0,8'hFC);
    @(posedge clock);
    payload(1'b0,8'hAF);
    @(posedge clock);
    payload(1'b0,8'hAB);
    @(posedge clock);
    payload(1'b0,8'hAC);
    @(posedge clock);
    payload(1'b0,8'hAD);
    @(posedge clock);
    payload(1'b0,8'hBC);
    @(posedge clock);
    payload(1'b0,8'hBD);
    @(posedge clock);
    payload(1'b0,8'hBF);
    @(posedge clock);
    payload(1'b0,8'hCF);
    @(posedge clock);
    payload(1'b0,8'hFA);
    @(posedge clock);
    payload(1'b0,8'hFB);
    @(posedge clock);
    payload(1'b0,8'hDC);
    @(posedge clock)
    w_off;
    read_t;
    soft_reset_t;
    @(posedge clock)
    write_enb_t;
    header(1'b1,8'b00001110);
    @(posedge clock);
    payload(1'b0,8'hFA);
    @(posedge clock);
    payload(1'b0,8'hFB);
    @(posedge clock);
    payload(1'b0,8'hDC);
    @(posedge clock)
    w_off;
    read_t;
    #1000 $finish;
end

initial
begin
    $monitor("time=%0t resetn=%b soft_reset=%b write_enb=%b read_enb=%b lfd_state=%b data_in=%h data_out=%H full=%b empty=%b",$time,resetn,soft_reset,write_enb,read_enb,lfd_state,data_in,data_out,full,empty);
end
endmodule
