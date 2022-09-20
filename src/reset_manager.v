//===================================================================================================
//                            ------->  Revision History  <------
//===================================================================================================
//
//   Date     Who   Ver  Changes
//===================================================================================================
// 14-Sep-22  DWW  1000  Initial creation
//===================================================================================================

module reset_manager
(
    // Clock and input reset signal.
    input clock, reset_in,
    
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_pb_out RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    output reg reset_pb_out,


    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 pma_init_out RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    output reg pma_init_out
);

reg[1:0] state = 0;
reg[31:0] counter;

always @(posedge clock) begin

    // The counter always counts down to zero
    if (counter) counter <= counter - 1;

    case(state)

        // When reset_in becomes active, assert reset_pb_out and wait for 128 clock cycles
        0:  if (reset_in) begin
                reset_pb_out <= 1;
                counter      <= 128;
                state        <= 1;                                
            end
        
        // After the timer expires, assert pma_init_out, and wait for 1,000,000 clock cycles
        1:  if (counter == 0) begin
                pma_init_out <= 1;
                counter      <= 1000000;
                state        <= 2;
            end 
        
        // After the timer expires, de-assert pma_init_out and wait for 10,000 clock cycles
        2:  if (counter == 0) begin
                pma_init_out <= 0;
                counter      <= 10000;
                state        <= 3;
            end 
        
        // When that timer expires, de-assert reset_pb_out.  The Aurora is now out of reset.
        3:  if (counter == 0) begin
                reset_pb_out <= 0;
                state        <= 0;
            end 
            
    endcase

end


endmodule
