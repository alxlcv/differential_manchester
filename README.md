# Differential manchester encoder/decoder
Simple and compact differential manchester encoder/decoder

IP consists of a baudrate generator, coder, decoder and DPLL modules.

The baudrate generator divides main clock and generate double ce2x signals for the encoder.

The encoder captures serial data gives out the finished differential manchester code.

DPLL takes edges on the input and automatically determines the current baudrate. 
This has an original adjustment system based on 2 counters and accurately captures of the signal in the center of the pulse. 
You can set up the baudrate manually using the divider. However, the PLL itself adjusts the current baudrate.

The decoder synchronizes the external signal, captures 3 bits to the buffer and decodes them using the original scheme.
