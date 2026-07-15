module router_reg(
    input clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,lfd_state,
    input [7:0]data_in,
    output reg parity_done,low_pkt_valid,err,
    output reg[7:0]dout
);
reg[7:0]header_reg;
reg [7:0]fifo_full_reg;
reg [7:0]parity_reg;
reg [7:0]packet_parity_reg;

//header register
always @(posedge clock)
begin
    if(!resetn)
    begin
         header_reg<=8'd0;
    end
    else if(detect_add && pkt_valid)
         header_reg<=data_in;
end

//fifo full reg
always @(posedge clock)
begin
    if(!resetn)
    begin
        fifo_full_reg<=8'd0;
    end
    else if (ld_state && fifo_full)
    begin
        fifo_full_reg<=data_in;
        if(!pkt_valid)
            low_pkt_valid<=1'b1;
        else
            low_pkt_valid<=1'b0;
    end
end


always @(posedge clock)
begin
    if (!resetn)
    begin
        parity_reg<=8'h00;
        packet_parity_reg<=8'h00;
        parity_done<=1'b0;
        err<=1'b0;
        low_pkt_valid<=1'b0;
    end
    else if(detect_add)
    begin
        parity_done <= 0;
    end
    else if(rst_int_reg)
    begin
        low_pkt_valid<=1'b0;
        parity_reg<=8'h00;
        packet_parity_reg <= 8'h00;
        err<=1'b0;
    end
    else if(lfd_state && pkt_valid && !fifo_full)
      begin
        parity_reg<=header_reg;
      end
    else if(ld_state  && pkt_valid && !fifo_full)
        begin
        parity_reg<=data_in^parity_reg;
        end
    else if(ld_state && !pkt_valid && !fifo_full)
      begin
        packet_parity_reg<=data_in;
        parity_done<=1'b1;
      end
    else if(laf_state && !low_pkt_valid)
    begin
        parity_reg <= parity_reg ^ fifo_full_reg;
    end
    else if(laf_state && low_pkt_valid)
    begin
        packet_parity_reg <= fifo_full_reg;
        parity_done <=1'b1;
    end
    else if(parity_done)
       begin
        if(parity_reg==packet_parity_reg)
            err<=1'b0;
        else
            err<=1'b1;
       end
end

always @(*)
begin
    dout = 8'h00;                      
    if (lfd_state && pkt_valid && !fifo_full)
        dout = header_reg;
    else if (ld_state && !fifo_full)
        dout = data_in;                
    else if (laf_state )
        dout = fifo_full_reg;
end

endmodule