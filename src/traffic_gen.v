`timescale 1ns / 1ps
//===================================================================================================
//                            ------->  Revision History  <------
//===================================================================================================
//
//   Date     Who   Ver  Changes
//===================================================================================================
// 08-Sep-22  DWW  1000  Initial creation
//===================================================================================================


`define M_AXI_ADDR_WIDTH 32
`define M_AXI_DATA_WIDTH 32
`define M_AXI_DATA_BYTES (`M_AXI_DATA_WIDTH/8)

module traffic_gen #(AXI_TARGET = 32'h4000_0000)
(
    input clk, resetn,


    //============================  An AXI-Lite Master Interface  ===================================

    // "Specify write address"        -- Master --    -- Slave --
    output[`M_AXI_ADDR_WIDTH-1:0]     M_AXI_AWADDR,   
    output                            M_AXI_AWVALID,  
    output[2:0]                       M_AXI_AWPROT,
    input                                             M_AXI_AWREADY,

    // "Write Data"                   -- Master --    -- Slave --
    output[`M_AXI_DATA_WIDTH-1:0]     M_AXI_WDATA,      
    output                            M_AXI_WVALID,
    output[`M_AXI_DATA_BYTES-1:0]     M_AXI_WSTRB,
    input                                             M_AXI_WREADY,

    // "Send Write Response"          -- Master --    -- Slave --
    input[1:0]                                        M_AXI_BRESP,
    input                                             M_AXI_BVALID,
    output                            M_AXI_BREADY,

    // "Specify read address"         -- Master --    -- Slave --
    output[`M_AXI_ADDR_WIDTH-1:0]     M_AXI_ARADDR,     
    output                            M_AXI_ARVALID,
    output[2:0]                       M_AXI_ARPROT,     
    input                                             M_AXI_ARREADY,

    // "Read data back to master"     -- Master --    -- Slave --
    input[`M_AXI_DATA_WIDTH-1:0]                       M_AXI_RDATA,
    input                                              M_AXI_RVALID,
    input[1:0]                                         M_AXI_RRESP,
    output                            M_AXI_RREADY
    //===============================================================================================
);

    // Some convenience parameters
    localparam M_AXI_ADDR_WIDTH = `M_AXI_ADDR_WIDTH;
    localparam M_AXI_DATA_WIDTH = `M_AXI_DATA_WIDTH;

    //===============================================================================================
    // We'll communicate with the AXI4-Lite Master core with these signals.
    //===============================================================================================


    // AXI Master Control Interface for AXI writes
    reg [M_AXI_ADDR_WIDTH-1:0] amci_waddr;
    reg [M_AXI_DATA_WIDTH-1:0] amci_wdata;
    reg                        amci_write;
    wire[                 1:0] amci_wresp;
    wire                       amci_widle;
   
    // AXI Master Control Interface for AXI reads
    reg [M_AXI_ADDR_WIDTH-1:0] amci_raddr;
    reg                        amci_read;
    wire[M_AXI_DATA_WIDTH-1:0] amci_rdata;
    wire[                 1:0] amci_rresp;
    wire                       amci_ridle;
    //===============================================================================================


    reg[3:0] fsm_state;
    reg[3:0] leds;
    reg[31:0] counter;

    always @(posedge clk) begin
        
        amci_write <= 0;

        if (resetn == 0) begin
            fsm_state <= 0;
            leds      <= 1;
            counter   <= 0;
        end

        else case (fsm_state)
            0:  if (amci_widle) begin
                    amci_waddr <= AXI_TARGET;
                    amci_wdata <= leds;
                    amci_write <= 1;
                    counter    <= 0;
                    fsm_state  <= 1;
                end

            1:  if (counter == 10000000) begin
                    leds      <= (leds == 0) ? 1 : (leds << 1);
                    fsm_state <= 0;
                end else
                    counter <= counter + 1;
        endcase
        
    end


    //===============================================================================================
    // This connects us to an AXI4-Lite master core that drives the system interconnect
    //===============================================================================================
    axi4_lite_master# 
    (
        .AXI_ADDR_WIDTH(M_AXI_ADDR_WIDTH),
        .AXI_DATA_WIDTH(M_AXI_DATA_WIDTH)        
    )
    axi_master_to_system
    (
        .clk            (clk),
        .resetn         (resetn),
        
        // AXI AW channel
        .AXI_AWADDR     (M_AXI_AWADDR ),
        .AXI_AWVALID    (M_AXI_AWVALID),   
        .AXI_AWPROT     (M_AXI_AWPROT ),
        .AXI_AWREADY    (M_AXI_AWREADY),
        
        // AXI W channel
        .AXI_WDATA      (M_AXI_WDATA ),
        .AXI_WVALID     (M_AXI_WVALID),
        .AXI_WSTRB      (M_AXI_WSTRB ),
        .AXI_WREADY     (M_AXI_WREADY),

        // AXI B channel
        .AXI_BRESP      (M_AXI_BRESP ),
        .AXI_BVALID     (M_AXI_BVALID),
        .AXI_BREADY     (M_AXI_BREADY),

        // AXI AR channel
        .AXI_ARADDR     (M_AXI_ARADDR ), 
        .AXI_ARVALID    (M_AXI_ARVALID),
        .AXI_ARPROT     (M_AXI_ARPROT ),
        .AXI_ARREADY    (M_AXI_ARREADY),

        // AXI R channel
        .AXI_RDATA      (M_AXI_RDATA ),
        .AXI_RVALID     (M_AXI_RVALID),
        .AXI_RRESP      (M_AXI_RRESP ),
        .AXI_RREADY     (M_AXI_RREADY),

        // AMCI write registers
        .AMCI_WADDR     (amci_waddr),
        .AMCI_WDATA     (amci_wdata),
        .AMCI_WRITE     (amci_write),
        .AMCI_WRESP     (amci_wresp),
        .AMCI_WIDLE     (amci_widle),

        // AMCI read registers
        .AMCI_RADDR     (amci_raddr),
        .AMCI_RDATA     (amci_rdata),
        .AMCI_READ      (amci_read ),
        .AMCI_RRESP     (amci_rresp),
        .AMCI_RIDLE     (amci_ridle)
    );
    //===============================================================================================




endmodule