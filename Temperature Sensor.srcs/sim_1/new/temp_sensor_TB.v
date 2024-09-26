`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2024 03:57:11 PM
// Design Name: 
// Module Name: temp_sensor_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module temp_sensor_TB();

// Inputs
reg clk;
reg rst;
reg start_button;

// Bidirectional I2C lines
reg sda_drive;
wire sda;
wire scl;

// Outputs
wire [7:0] seg;  // Segments for 7-segment display
wire [3:0] an;   // Anode control for 4-digit display

// Instantiate the Temperature Sensor module
temp_sensor uut (
    .clk(clk),
    .rst(rst),
    .start_button(start_button),
    .sda(sda),
    .scl(scl),
    .seg(seg),
    .an(an)
);

// I2C SDA signal control (for bidirectional simulation)
assign sda = sda_drive ? 1'b0 : 1'bz;  // SDA is driven low by the testbench, otherwise high-Z

// Clock generation
initial begin
    clk = 0;                // Initialize clock
    forever #5 clk = ~clk;  // 100 MHz clock
end

// Test sequence
initial begin
    // Initialize signals
    rst = 1;                 // Start with reset
    start_button = 0;       // Start button not pressed
    sda_drive = 1;          // SDA is initially high (idle)

    // Reset the system
    #10;
    rst = 0;                // Release reset
    
    // Simulate pressing the start button to trigger temperature reading
    #20;
    start_button = 1;       // Press start button
    
    // Simulate I2C communication process (mock response from sensor)
    #50;
    sda_drive = 0;          // Mock sensor pulling SDA low during communication
    
    // Release the button
    #30;
    start_button = 0;       // Release start button
    
    // Release SDA after I2C communication
    #100;
    sda_drive = 1;          // Release SDA (mock end of I2C transaction)
    
    // Let the system run for a while to observe behavior
    #500;
    
    // Finish simulation
    $finish;
end

// Monitor outputs
initial begin
    $monitor("Time = %0d, Segments = %b, Anode = %b, SDA = %b, SCL = %b",
             $time, seg, an, sda, scl);
end

endmodule

