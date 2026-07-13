module  fifo(
    input resetn,clock,soft_reset,lfd_state,write_enb,read_enb,
    input [7:0]data_in,
    output reg [7:0]data_out,
    output full,empty
    );
    reg [4:0]read_ptr,write_ptr;
    reg [8:0]mem[0:15];
    reg [6:0]count;


//payload length count logic
always @(posedge clock)
begin
    if (!resetn)
       count <= 0;
    else if(soft_reset)
       count <= 0;
    else if(read_enb && !empty)
    begin
        if(mem[read_ptr[3:0]][8]==1'b1)
             count<=(mem[read_ptr[3:0]][7:2])+1'b1;
        else if(count!=0)
             count<=count-1;
    end
    
end



//read
always @(posedge clock)
begin
    if (!resetn)
    begin
       data_out <= 8'b0;
       read_ptr<=0;
    end
    else if(soft_reset)
    begin
       data_out <= 8'bz;
       read_ptr<=0;
       end

    else if(read_enb && !empty)
    begin
    if(count==0)
      begin
          data_out<=8'bz;
      end
      else
       begin
         data_out<=mem[read_ptr[3:0]][7:0];
         read_ptr<=read_ptr+1;
         end
    end
end


integer i;
//write 
always @(posedge clock)
begin
    if (!resetn)
    begin
      for(i=0;i<16;i=i+1)
         mem[i] <= 9'b0;
       write_ptr<=0;
    end
    else if(soft_reset)
    begin
       write_ptr<=0;
    end
    else if(write_enb && !full)
    begin
        mem[write_ptr[3:0]]<={lfd_state,data_in};
        write_ptr<=write_ptr+1;
    end
end

assign empty = (write_ptr==read_ptr);
assign full = ((write_ptr[3:0]==read_ptr[3:0])&& (write_ptr[4]!=read_ptr[4]));

endmodule
