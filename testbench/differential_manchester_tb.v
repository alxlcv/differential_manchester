`timescale 1ns/1ns

module differential_manchester_tb;

    parameter                   ACCUMULATOR_WIDTH   = 16;
    parameter                   COUNTER_WIDTH       = 16;
    parameter                   USE_FILTER          = 0;

    parameter                   TX_DIVIDER          = 16'h32;
    parameter                   RX_DIVIDER          = 16'h41;    
    
    reg                         clk = 0;
    reg                         rst = 1'b1;
    
    wire                        tx_ce2x;
    wire                        tx_ce;
    wire [7 : 0]                lfsr;
    wire                        txd;
    
    wire                        rx_slew;
    wire                        rx_ce2x;


    always #4 clk = ~clk; 


    // Baudrate generator with 2x ce
    brg
    #(
        .COUNTER_WIDTH         ( COUNTER_WIDTH        )
    )
    BRG_UUT
    (
        .clk                   (clk                   ),
        .rst                   (rst                   ),
        .slew                  (1'b0                  ),
        .div                   (TX_DIVIDER            ),
        .ce                    (tx_ce2x               )
    );

    // Pseudorandom generator
    rnd RND
    (
        .clk                   (clk                   ),
        .rst                   (rst                   ),
        .ce                    (tx_ce                 ),
        .lfsr                  (lfsr                  )
    );

    // Transmitter/coder
    encoder TX_UUT
    (
        .clk                   (clk                   ),
        .rst                   (rst                   ),
        .tx_ce2x               (tx_ce2x               ),
        .tx_sdata              (lfsr[0]               ),
        .tx_ce                 (tx_ce                 ),
        .txd                   (txd                   ),
        .carrier               (                      )
    );

    // -------------------------------------------------
    // Receiver digital PLL
    dpll
    #(
        .USE_FILTER            ( USE_FILTER           ),    
        .ACCUMULATOR_WIDTH     ( ACCUMULATOR_WIDTH    ),
        .COUNTER_WIDTH         ( COUNTER_WIDTH        )
    )
    DPLL_UUT
    (
        .clk                   (clk                   ),
        .rst                   (rst                   ),
        .slew                  (rx_slew               ),
        .div                   (RX_DIVIDER            ),
        .ce                    (rx_ce2x               ),
        .clr                   (                      ),
        .correct_div           (                      )
    );

    // Receiver/decoder
    decoder RX_UUT
    (
        .clk                   (clk                   ),
        .rst                   (rst                   ), 
        .rx_ce2x               (rx_ce2x               ),
        .rx_sdata              (                      ),
        .rx_slew               (rx_slew               ),
        .rx_sync               (                      ),
        .rx_ce                 (                      ),
        .rxd                   (txd                   ),
        .carrier               (                      )
    );



    initial begin
        #100 rst = 0;
        #2000000

        $write("Simulation has finished\n");
        $finish;
    end


    initial begin
        $dumpfile("differential_manchester_tb.vcd");
        $dumpvars(0,differential_manchester_tb);
    end

endmodule

