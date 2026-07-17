module router1x3_tb();
    reg clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid;
    reg [7:0]data_in;
    wire vld_out_0,vld_out_1,vld_out_2;
    wire err,busy;
    wire [7:0]data_out_0,data_out_1,data_out_2;

router1x3 dut (
    .clock      (clock),
    .resetn     (resetn),
    .read_enb_0 (read_enb_0),
    .read_enb_1 (read_enb_1),
    .read_enb_2 (read_enb_2),
    .pkt_valid  (pkt_valid),
    .data_in    (data_in),

    .vld_out_0(vld_out_0),
    .vld_out_1(vld_out_1),
    .vld_out_2(vld_out_2),
    .err        (err),
    .busy       (busy),

    .data_out_0 (data_out_0),
    .data_out_1 (data_out_1),
    .data_out_2 (data_out_2)
);


initial
begin
    clock=0;
    forever #5 clock=~clock;
end


task init;
begin
    resetn = 1'b1;
    read_enb_0=1'b0;
    read_enb_1=1'b0;
    read_enb_2=1'b0;
    pkt_valid=1'b0;
end
endtask

task rst;
begin
    @(negedge clock);
    resetn=1'b0;
    @(negedge clock);
    resetn=1'b1;
end
endtask

task header;
input[7:0]data;
begin
    data_in=data;
    @(posedge clock);
end
endtask

task packet;
input[7:0]data;
begin
    data_in=data;
    @(posedge clock);
end
endtask

task read0;
begin
    read_enb_0=1'b1;
    repeat(7)
    @(posedge clock);
    read_enb_0=1'b0;
    @(posedge clock);
end
endtask

task read1;
begin
    read_enb_1=1'b1;
    repeat(6)
    @(posedge clock);
    read_enb_1=1'b0;
    @(posedge clock);
end
endtask

task read2;
begin
    read_enb_2=1'b1;
    repeat(10)
    @(posedge clock);
    read_enb_2=1'b0;
    @(posedge clock);
end
endtask

initial
begin
    //test1   normal packet
    init;
    rst;
    pkt_valid=1'b1;
    header(8'h10);
    @(posedge clock);
    packet(8'hAA);
    packet(8'h55);
    packet(8'hF0);
    packet(8'h0F);
    pkt_valid=1'b0;
    packet(8'h10);
    read0;
    #10
    //test2 err test
    pkt_valid=1'b1; 
    header(8'h0D);
    @(posedge clock);
    @(posedge clock);
    packet(8'h12);
    packet(8'h34);         
    packet(8'h56);
    pkt_valid=1'b0;
    packet(8'h7C);
    read1;
    #10
//test3 full test
    init;
    rst;
    pkt_valid = 1'b1;
header(8'h42);   // Header , DA=2
@(posedge clock);
packet(8'h11);   // Payload1
packet(8'h22);   // Payload2
packet(8'h33);   // Payload3
packet(8'h44);   // Payload4
packet(8'h55);   // Payload5
packet(8'h66);   // Payload6
packet(8'h77);   // Payload7
packet(8'h88);   // Payload8
packet(8'h99);   // Payload9
packet(8'hAA);   // Payload10
packet(8'hBB);   // Payload11
packet(8'hCC);   // Payload12
packet(8'hDD);   // Payload13
packet(8'hEE);   // Payload14
packet(8'hF1);   // Payload15
packet(8'hF2);   // Payload16  <-- FIFO should become FULL here

pkt_valid = 1'b0;
packet(8'hBE);   // Parity
read2;

//test4 payload length=1
init;
rst;
pkt_valid=1'b1;
header(8'h06);
@(posedge clock);
packet(8'h01);
pkt_valid=1'b0;
packet(8'h04);
read_enb_2=1'b1;
    repeat(4)
    @(posedge clock);
    read_enb_2=1'b0;
    @(posedge clock);

//test5 Packet to all three FIFOs
// FIFO0
init;
rst;
pkt_valid = 1;
header(8'h08);
@(posedge clock);
packet(8'hAA);
packet(8'hBB);
pkt_valid = 0;
packet(8'h19);

@(posedge clock);     // Give router one clock to return to DECODE_ADDRESS

// FIFO1
pkt_valid = 1;
header(8'h09);
@(posedge clock);
packet(8'h11);
packet(8'h22);
pkt_valid = 0;
packet(8'h38);

@(posedge clock);     // Again one clock gap

// FIFO2
pkt_valid = 1;
header(8'h0A);
@(posedge clock);
packet(8'h33);
packet(8'h44);
pkt_valid = 0;
packet(8'h79);

@(posedge clock);

read0;
read1;
read2;

//test 6 Read from the wrong FIFO
init;
rst;

pkt_valid = 1;
header(8'h06);   // DA = 2

@(posedge clock);
packet(8'hAA);

pkt_valid = 0;
packet(8'hAC);

// Wrong FIFO
read0;

// Correct FIFO
read2;
    #1000 $finish;
end

endmodule
