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
    repeat(13)
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
   // Test : Multiple packets to the SAME FIFO (FIFO0)
init;
rst;

//Packet 1
pkt_valid = 1'b1;
header(8'h10);  // Length=4, DA=00 (FIFO0)
@(posedge clock);
packet(8'hAA);
packet(8'h55);
packet(8'hF0);
packet(8'h0F);
pkt_valid = 1'b0;
packet(8'h10);  // Parity
@(posedge clock);
@(posedge clock);

//packet 2 
pkt_valid = 1'b1;
header(8'h10);  
@(posedge clock);
packet(8'h11);
packet(8'h22);
packet(8'h33);
packet(8'h44);
pkt_valid = 1'b0;
packet(8'h44);     

repeat(3)
    @(posedge clock);

// Read FIFO0
read0;
    #10
//test2 full test with reset
    init;
    rst;
    pkt_valid = 1'b1;
header(8'h42);   // Header
packet(8'h11);   
packet(8'h22);  
packet(8'h33);  
packet(8'h44);  
packet(8'h55);  
packet(8'h66);  
packet(8'h77);   
packet(8'h88); 
packet(8'h99);   
packet(8'hAA);   
packet(8'hBB);   
packet(8'hCC);   
packet(8'hDD);   
packet(8'hEE);  
packet(8'hF1);   
packet(8'hF2);   // Payload16  <-- FIFO should become FULL here and these not include
rst;
pkt_valid = 1'b0;
packet(8'hBE);   // Parity
read2;


//test intentinally give pkt_valid glitch

init;
rst;
pkt_valid = 1;
header(8'h10);
@(posedge clock);
packet(8'hAA);
// Illegal
pkt_valid = 0;
packet(8'h55);
pkt_valid = 1;
packet(8'hF0);
pkt_valid = 0;
packet(8'h4D); // parity

//test - during empty time give write 
init;
rst;
pkt_valid = 1;
header(8'h10);
@(posedge clock);
packet(8'hAA);
packet(8'h55);
pkt_valid = 0;
packet(8'hEF);
read_enb_0 = 1;

pkt_valid = 1;
header(8'h10);
packet(8'h11);
packet(8'h22);

pkt_valid = 0;
packet(8'h33);

//test - Read exactly on timeout boundary
init;
rst;

pkt_valid=1;
header(8'h06);

@(posedge clock);

packet(8'hAA);

pkt_valid=0;
packet(8'hAC);

    repeat(26)       //this reaches upto count of 29 
@(posedge clock);

read2;
    #2000 $finish;
end

endmodule
