module dpll
#(
    parameter           USE_FILTER          = 1,
    parameter           FILTER_LENGHT       = 6,
    parameter           ACCUMULATOR_WIDTH   = 16,
    parameter           COUNTER_WIDTH       = 16
)
(
    input                                   rst,
    input                                   clk,
    input                                   slew,
    input   [COUNTER_WIDTH - 1 : 0]         div,
    output                                  ce,
    output                                  clr,
    output  [COUNTER_WIDTH - 1 : 0]         correct_div
);

    reg     [FILTER_LENGHT - 1 : 0]         filter_cnt;
    wire    [FILTER_LENGHT - 1 : 0]         new_filter_cnt;    
    reg     [ACCUMULATOR_WIDTH - 1 : 0]     acc;
    reg     [COUNTER_WIDTH - 1 : 0]         div_cnt;
    wire    [COUNTER_WIDTH - 1 : 0]         sub_div_cnt;

    wire    [FILTER_LENGHT - 1 : 0]         next_filter_cnt_up;
    wire    [FILTER_LENGHT - 1 : 0]         next_filter_cnt_down;
    wire                                    clear_filter;
    wire                                    up_correct;
    wire                                    down_correct;

    generate
    if (USE_FILTER == 1) begin
    
        // Filter
        assign next_filter_cnt_up   = clear_filter ? {1'b1, {FILTER_LENGHT - 1{1'b0}}} : filter_cnt + { {FILTER_LENGHT - 1{1'b0}}, {1'b1} };
        assign next_filter_cnt_down = clear_filter ? {1'b1, {FILTER_LENGHT - 1{1'b0}}} : filter_cnt - { {FILTER_LENGHT - 1{1'b0}}, {1'b1} };

        assign clear_filter = up_correct | down_correct;
        assign up_correct   = (filter_cnt == {FILTER_LENGHT{1'b1}}) & clr  & ~slew;
        assign down_correct = (filter_cnt == {FILTER_LENGHT{1'b0}}) & slew & ~clr;
    
        always @(posedge clk or posedge rst)
            if(rst) 
                filter_cnt <= {1'b1, {FILTER_LENGHT - 1{1'b0}}};
            else if (slew & ~clr)  
                filter_cnt <= next_filter_cnt_down;
            else if (clr  & ~slew) 
                filter_cnt <= next_filter_cnt_up;
        
    end else begin
    
        // Without filter
        assign up_correct   = clr  & ~slew;
        assign down_correct = slew & ~clr;
        
    end
    endgenerate
    
    // Correction
    always @(posedge clk or posedge rst)
        if(rst) 
            acc <= {ACCUMULATOR_WIDTH{1'b0}};
        else if (down_correct)
            acc <= acc - {{ACCUMULATOR_WIDTH - 1{1'b0}}, {1'b1}};
        else if (up_correct)    
            acc <= acc + {{ACCUMULATOR_WIDTH - 1{1'b0}}, {1'b1}};


    assign correct_div = div     + acc[ACCUMULATOR_WIDTH - 1 : ACCUMULATOR_WIDTH - COUNTER_WIDTH];
    assign sub_div_cnt = div_cnt - {{COUNTER_WIDTH - 1{1'b0}}, {1'b1}};


    // Main divider
    always @(posedge clk or posedge rst)
        if(rst) 
            div_cnt <= {COUNTER_WIDTH{1'b0}};
        else if (clr | slew) 
            div_cnt <= correct_div;
        else 
            div_cnt <= sub_div_cnt;

    assign clr = (div_cnt     == {COUNTER_WIDTH{1'b0}});
    assign ce  = (sub_div_cnt == {1'b0, correct_div[COUNTER_WIDTH - 1 : 1]});

endmodule
