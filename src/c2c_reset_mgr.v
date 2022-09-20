//===================================================================================================
//                            ------->  Revision History  <------
//===================================================================================================
//
//   Date     Who   Ver  Changes
//===================================================================================================
// 14-Sep-22  DWW  1000  Initial creation
//===================================================================================================

module c2c_reset_mgr
(
    // Clock and input reset signal.
    input clock, reset_in,
    
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_out RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    output reg reset_out

);

reg power_on_reset = 1;
reg[1:0] state = 0;
reg[31:0] counter;

always @(posedge clock) begin

    // The counter always counts down to zero
    if (counter) counter <= counter - 1;

    case(state)

        // If we've just received a reset signal, delay for two seconds
        // to allow the Chip2Chip master to come out of reset first.
        0:  if (reset_in | power_on_reset) begin
                reset_out      <= 1;
                power_on_reset <= 0;
                counter        <= 2000000;
                state          <= 1;                                
            end
        
        // Before we allow another reset, we're going to wait 500ms for
        // things to stabilize
        1:  if (counter == 0) begin
                reset_out    <= 0;
                counter      <= 500000;
                state        <= 2;
            end 

        // At the end of that delay, go back to waiting for a reset signal        
        2:  if (counter == 0) state <= 0;
            
    endcase

end


endmodule
