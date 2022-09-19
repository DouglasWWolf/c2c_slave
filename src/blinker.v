module binker
(
    input wire CLK, RESETN,
    output LED
);
    localparam LIMIT = 100000000 / 10;

    reg led; assign LED = led;

    reg[31:0] counter;

    
    always @(posedge CLK) begin
        if (RESETN == 0) begin
            led     <= 0;
            counter <= LIMIT;
        end else if (counter)
            counter <= counter - 1;
        else begin
            counter <= LIMIT;
            led     <= ~led;
        end
    end



endmodule
