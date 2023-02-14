module rnd
(
    input                                   clk,
    input                                   rst,
    input                                   ce,
    output reg [7 : 0]                      lfsr
);

    wire                                    feedback;

    assign feedback = lfsr[7];

    always @(posedge clk or posedge rst)
        if (rst)
                lfsr <= 8'hff;
        else if (ce) 
            begin
                lfsr[0] <= feedback;
                lfsr[1] <= lfsr[0];
                lfsr[2] <= lfsr[1] ^ feedback;
                lfsr[3] <= lfsr[2] ^ feedback;
                lfsr[4] <= lfsr[3] ^ feedback;
                lfsr[5] <= lfsr[4];
                lfsr[6] <= lfsr[5];
                lfsr[7] <= lfsr[6];
             end

endmodule
