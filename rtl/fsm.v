module fsm (
    input resetn,clock,pkt_valid,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,
    input [1:0] data_in,
    input parity_done,
    output reg ld_state,busy,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,detect_add
);
reg [2:0]state,next_state;
reg [1:0]addr; 

localparam [2:0]
            DECODE_ADDRESS=3'b000,
            LOAD_FIRST_DATA=3'b001,
            LOAD_DATA=3'b010,
            FIFO_FULL_STATE=3'b011,
            LOAD_AFTER_FULL=3'b100,
            LOAD_PARITY=3'b101,
            CHECK_PARITY_ERROR=3'b110,
            WAIT_TILL_EMPTY=3'b111;

//present_state
always @(posedge clock)
begin
    if(!resetn)
    begin
    state<=DECODE_ADDRESS;
    addr <= 2'b00;
    end
    else
    begin
        if ((soft_reset_0 && addr == 2'd0) ||
        (soft_reset_1 && addr == 2'd1) ||
        (soft_reset_2 && addr == 2'd2))
        state <= DECODE_ADDRESS;
    else
    state<=next_state;

    if(state==detect_add)
          addr <= data_in;
    end
end


//next_state
always @(*) begin
    case (state)
        DECODE_ADDRESS: if(((pkt_valid & (data_in[1:0] == 0) & fifo_empty_0) || (pkt_valid & (data_in[1:0] == 1) & fifo_empty_1) || (pkt_valid & (data_in[1:0] == 2) & fifo_empty_2) ))
                            next_state=LOAD_FIRST_DATA;
                        else if(((pkt_valid & (data_in[1:0] == 0) & !fifo_empty_0) || (pkt_valid & (data_in[1:0] == 1) & !fifo_empty_1) || (pkt_valid & (data_in[1:0] == 2) & !fifo_empty_2) ))
                            next_state=WAIT_TILL_EMPTY;
                        else
                            next_state=DECODE_ADDRESS;    
        LOAD_FIRST_DATA: next_state=LOAD_DATA;
        LOAD_DATA:if(fifo_full)
                       next_state=FIFO_FULL_STATE;
                  else if (!fifo_full&&!pkt_valid)
                       next_state=LOAD_PARITY;
                  else
                       next_state=LOAD_DATA;
        FIFO_FULL_STATE:if(!fifo_full)
                           next_state=LOAD_AFTER_FULL;
                        else
                           next_state=FIFO_FULL_STATE;
        LOAD_AFTER_FULL:if(!parity_done && !low_pkt_valid)
                           next_state=LOAD_DATA;
                        else if(!parity_done && low_pkt_valid)
                            next_state=LOAD_PARITY;
                        else
                            next_state=DECODE_ADDRESS;
        LOAD_PARITY:next_state=CHECK_PARITY_ERROR;
        CHECK_PARITY_ERROR:if(!fifo_full)
                                  next_state=DECODE_ADDRESS; 
                            else
                                  next_state=FIFO_FULL_STATE;
        WAIT_TILL_EMPTY:if((pkt_valid && fifo_empty_0 && (addr==0))|| (pkt_valid && fifo_empty_1 && (addr == 1))||(pkt_valid && fifo_empty_2 && (addr==2)))
                                  next_state=LOAD_FIRST_DATA;
                        else
                                  next_state=WAIT_TILL_EMPTY;
        default: next_state=DECODE_ADDRESS;
    endcase
end

//output
    always@(*)
    begin
                            detect_add    = 0;
                            lfd_state     = 0;
                            ld_state      = 0;
                            laf_state     = 0;
                            full_state    = 0;
                            write_enb_reg = 0;
                            rst_int_reg   = 0;
                            busy          = 0;   
        case(state)
               DECODE_ADDRESS:detect_add=1'b1;
               LOAD_FIRST_DATA:begin
                               lfd_state=1'b1;
                               busy=1'b1;
                               write_enb_reg = 1'b1;
               end
               LOAD_DATA:begin
                         ld_state=1'b1;
                         write_enb_reg = 1'b1;
               end
               FIFO_FULL_STATE:                      //fifo logic
               begin
                               full_state=1'b1;
                               busy=1'b1;
               end
               LOAD_AFTER_FULL:begin
                               laf_state=1'b1;
                               write_enb_reg = 1'b1;
               end
               LOAD_PARITY:begin
                               busy=1'b1;
               end
               CHECK_PARITY_ERROR:if(!fifo_full)
                                    rst_int_reg=1'b1;
                                  else
                                  begin
                                     full_state=1'b1;
                                     busy=1'b1;
                                  end
               WAIT_TILL_EMPTY:begin
                                 write_enb_reg=1'b0;
                                 busy=1'b1;
               end
        endcase
    end

endmodule