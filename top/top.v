module router1x3(
    input clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,
    input [7:0]data_in,
    output vld_out_0,vld_out_1,vld_out_2,
    output err,busy,
    output [7:0]data_out_0,data_out_1,data_out_2
);

wire soft_reset_0,soft_reset_1,soft_reset_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,detect_add,fifo_full,low_pkt_valid,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,parity_done;
wire [2:0] write_enb;
wire [7:0] dout;

fifo FIFO_0(
           .resetn(resetn),
           .clock(clock),
           .soft_reset(soft_reset_0),
           .lfd_state(lfd_state),
           .write_enb(write_enb[0]),
           .read_enb(read_enb_0),
           .data_in(dout),
           .data_out(data_out_0),
           .full(full_0),
           .empty(empty_0)
           );


fifo FIFO_1(
           .resetn(resetn),
           .clock(clock),
           .soft_reset(soft_reset_1),
           .lfd_state(lfd_state),
           .write_enb(write_enb[1]),
           .read_enb(read_enb_1),
           .data_in(dout),
           .data_out(data_out_1),
           .full(full_1),
           .empty(empty_1)
           );

fifo FIFO_2(
           .resetn(resetn),
           .clock(clock),
           .soft_reset(soft_reset_2),
           .lfd_state(lfd_state),
           .write_enb(write_enb[2]),
           .read_enb(read_enb_2),
           .data_in(dout),
           .data_out(data_out_2),
           .full(full_2),
           .empty(empty_2)
           );

router_sync Synchronizer(
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
                        .data_in(data_in[1:0]),
                        .vld_out_0(vld_out_0),
                        .vld_out_1(vld_out_1),
                        .vld_out_2(vld_out_2),
                        .soft_reset_0(soft_reset_0),
                        .soft_reset_1(soft_reset_1),
                        .soft_reset_2(soft_reset_2),
                        .fifo_full(fifo_full),
                        .write_enb(write_enb)
);

fsm  FSM(
        .resetn(resetn),
        .clock(clock),
        .pkt_valid(pkt_valid),
        .busy(busy),
        .low_pkt_valid(low_pkt_valid),
        .fifo_empty_0(empty_0),
        .fifo_empty_1(empty_1),
        .fifo_empty_2(empty_2),
        .soft_reset_0(soft_reset_0),
        .soft_reset_1(soft_reset_1),
        .soft_reset_2(soft_reset_2),
        .fifo_full(fifo_full),
        .data_in(data_in[1:0]),
        .detect_add(detect_add),
        .parity_done(parity_done),
        .ld_state(ld_state),
        .laf_state(laf_state),
        .full_state(full_state),
        .write_enb_reg(write_enb_reg),
        .rst_int_reg(rst_int_reg),
        .lfd_state(lfd_state)
        
);

router_reg Register(
                    .clock(clock),
                    .resetn(resetn),
                    .pkt_valid(pkt_valid),
                    .fifo_full(fifo_full),
                    .rst_int_reg(rst_int_reg),
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

endmodule