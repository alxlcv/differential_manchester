module encoder(
    input                                   clk,
    input                                   rst,
    input                                   tx_ce2x,
    input                                   tx_sdata,
    output                                  tx_ce,
    output reg                              txd,
    output reg                              carrier
);


    reg                                     sdat;
    wire                                    tx_ce2;


    assign tx_ce  =  carrier & tx_ce2x;
    assign tx_ce2 = ~carrier & tx_ce2x;

    always @(posedge clk or posedge rst)
        if(rst) 
            carrier <= 1'b0;
        else if (tx_ce2x) 
            carrier <= ~carrier;

    always @(posedge clk or posedge rst)
        if(rst) 
            txd <= 1'b0;
        else if ((tx_ce2 & tx_sdata) | tx_ce ) 
            txd <= ~txd;

endmodule

