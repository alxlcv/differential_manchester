module brg 
#(
    parameter           COUNTER_WIDTH       = 16
)
(
    input                                   clk,
    input                                   rst,
    input                                   slew,
    input   [COUNTER_WIDTH - 1 : 0]         div,
    output  wire                            ce
);

    reg     [COUNTER_WIDTH - 1 : 0]         div_cnt; 
    wire    [COUNTER_WIDTH - 1 : 0]         sub_div_cnt;
    wire                                    clr;


    assign sub_div_cnt = div_cnt - {{COUNTER_WIDTH - 1{1'b0}}, {1'b1}};

    always @(posedge clk or posedge rst)
        if(rst) 
            div_cnt <= {COUNTER_WIDTH{1'b0}};
        else if (clr) 
            div_cnt <= div;
        else 
            div_cnt <= sub_div_cnt;

    assign clr = (div_cnt     == {COUNTER_WIDTH{1'b0}}) | slew;
    assign ce  = (sub_div_cnt == {1'b0, div[COUNTER_WIDTH - 1 : 1]});

endmodule
