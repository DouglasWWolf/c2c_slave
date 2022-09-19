//===================================================================================================
//                            ------->  Revision History  <------
//===================================================================================================
//
//   Date     Who   Ver  Changes
//===================================================================================================
// 14-Sep-22  DWW  1000  Initial creation
//===================================================================================================

module bandwidth_test
(

    input clock, reset,

    output reg[63:0] xfer_time,
    output reg[31:0] rcvd_data,

    //=================================  AXI Input Stream interface  ================================
    input [255:0] IN_AXIS_TDATA,
    input         IN_AXIS_TVALID,
    input         IN_AXIS_TLAST,
    output reg    IN_AXIS_TREADY,
    //===============================================================================================



    //=================================  AXI Output Stream interface  ================================
    output reg[255:0] OUT_AXIS_TDATA,
    output reg        OUT_AXIS_TVALID,
    output reg        OUT_AXIS_TLAST,
    input             OUT_AXIS_TREADY
    //===============================================================================================

);
    localparam ONE_GB = 32'h0200_0000;

    reg[63:0] cycle_counter, start_counter;

    reg[2:0] osm_state;
    reg[31:0] xfer_count;

    always @(posedge clock) begin

        cycle_counter <= cycle_counter + 1;

        if (reset == 1) begin
            cycle_counter   <= 0;
            OUT_AXIS_TVALID <= 0;
            xfer_time       <= 0;
            osm_state       <= 0;
        
        end else case(osm_state)

            0:  begin
                    start_counter   <= cycle_counter;
                    xfer_count      <= ONE_GB;
                    osm_state       <= 1;
                end

            1:  begin
                    OUT_AXIS_TDATA  <= cycle_counter;
                    OUT_AXIS_TVALID <= 1;
                    OUT_AXIS_TLAST  <= 1;
                    
                    if (OUT_AXIS_TVALID && OUT_AXIS_TREADY) begin

                        if (xfer_count == 1) begin
                            xfer_time <= cycle_counter - start_counter;
                            OUT_AXIS_TVALID <= 0;
                            osm_state       <= 0;
                        end


                        xfer_count <= xfer_count - 1;
                    end

                end
        endcase
    end


    always @(posedge clock) begin

        if (reset == 1) begin
            IN_AXIS_TREADY <= 0;

        end else begin
            IN_AXIS_TREADY <= 1;
            if (IN_AXIS_TREADY && IN_AXIS_TVALID) rcvd_data <= IN_AXIS_TDATA[31:0];
        end
     end


endmodule
