module decoder(
    input                                   clk,
    input                                   rst, 
    input                                   rx_ce2x,
    output reg                              rx_sdata,
    output                                  rx_slew,
    output                                  rx_sync,
    output                                  rx_ce,
    input                                   rxd,
    output reg                              carrier
);


    reg [2 : 0]                             sync_rxd;
    reg [2 : 0]                             last_rxd;


    assign rx_ce = carrier & rx_ce2x;
    assign rx_sync = ~((~(|last_rxd)) | ( &last_rxd));

    always @(posedge clk or posedge rst)
        if(rst) 
            carrier <= 1'b0;
        else if (rx_ce2x) 
            carrier <= ~carrier;

    always @(posedge clk or posedge rst)
        if(rst) 
            sync_rxd <= 3'b000;
        else 
            sync_rxd <= {sync_rxd[1:0], rxd};

    assign rx_slew = sync_rxd[1] ^ sync_rxd[2];

    always @(posedge clk or posedge rst)
        if(rst) 
            last_rxd <= 3'b000;
        else if (rx_ce2x) 
            last_rxd <= {last_rxd[1:0], sync_rxd[1]};

    always @(posedge clk or posedge rst)
        if(rst) 
            rx_sdata <= 1'b0;
        else if (rx_ce) 
            rx_sdata <= ((last_rxd[1] ^ last_rxd[0]) & (last_rxd[2] ^ last_rxd[1]));

endmodule
