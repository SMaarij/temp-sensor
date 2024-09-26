`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2024 03:37:06 PM
// Design Name: 
// Module Name: temp_sensor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module temp_sensor(
    input clk,             // System clock
    input rst,             // Reset signal
    input start_button,    // Button to start I2C communication
    inout sda,             // I2C data line
    output scl,            // I2C clock line
    output [7:0] seg,      // 7-segment display segments (CA to CG)
    output reg [7:0] an        // 4 anodes for 4-digit display
);

// I2C parameters
parameter SLAVE_ADDR = 7'h4B;  // ADT7420 I2C slave address
parameter READ_CMD   = 1'b1;   // Read command
parameter WRITE_CMD  = 1'b0;   // Write command

// FSM States
parameter IDLE       = 3'd0,
          START      = 3'd1,
          ADDR       = 3'd2,
          READ_MSB   = 3'd3,
          READ_LSB   = 3'd4,
          STOP       = 3'd5,
          CONVERT    = 3'd6;

reg [2:0] state, next_state; // State registers

// I2C signals
reg scl_enable;        // Enable clock for I2C
reg sda_drive;         // Drive data on SDA
reg [7:0] data;        // Data to send/receive
reg [7:0] msb_data;    // MSB of temperature data
reg [7:0] lsb_data;    // LSB of temperature data

// 7-segment display signals
reg [15:0] temperature; // Temperature value in Celsius
reg [3:0] digit1, digit2, digit3, digit4; // Digits to display
reg [1:0] refresh_counter; // Counter for 7-segment display refresh

// I2C clock generation
reg [15:0] clk_count;
parameter SCL_FREQ_DIV = 250;  // Divide clock to generate SCL

// 7-segment encoding for digits 0-9
reg [7:0] seg_reg;

assign seg = seg_reg;

// Generate start_condition signal based on start_button press
reg start_condition;
always @(posedge clk or posedge rst) begin
    if (rst)
        start_condition <= 0;
    else if (start_button)
        start_condition <= 1;  // Set start condition when button is pressed
    else if (state != IDLE)
        start_condition <= 0;  // Clear start condition once FSM moves out of IDLE state
end

// Segment control logic for digits
always @(*) begin
    case (digit1)
        4'd0: seg_reg = 8'b11000000; // 0
        4'd1: seg_reg = 8'b11111001; // 1
        4'd2: seg_reg = 8'b10100100; // 2
        4'd3: seg_reg = 8'b10110000; // 3
        4'd4: seg_reg = 8'b10011001; // 4
        4'd5: seg_reg = 8'b10010010; // 5
        4'd6: seg_reg = 8'b10000010; // 6
        4'd7: seg_reg = 8'b11111000; // 7
        4'd8: seg_reg = 8'b10000000; // 8
        4'd9: seg_reg = 8'b10010000; // 9
        default: seg_reg = 8'b11111111; // Blank
    endcase
end

// Anode control (digit refresh)
always @(posedge clk) begin
    case (refresh_counter)
        2'b00: an <= 8'b11111110; // Activate the first digit
        2'b01: an <= 8'b11111101; // Activate the second digit
        2'b10: an <= 8'b11111011; // Activate the third digit
        2'b11: an <= 8'b11110111; // Activate the fourth digit
    endcase
end

// I2C clock (SCL) generation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        clk_count <= 0;
        scl_enable <= 0;
    end else if (clk_count < SCL_FREQ_DIV) begin
        clk_count <= clk_count + 1;
        scl_enable <= 0;
    end else begin
        clk_count <= 0;
        scl_enable <= 1;
    end
end

assign scl = scl_enable;

// FSM transitions
always @(posedge clk or posedge rst) begin
    if (rst)
        state <= IDLE;
    else
        state <= next_state;
end

// FSM logic for I2C communication
always @(*) begin
    case (state)
        IDLE: begin
            if (start_condition)
                next_state = START;
            else
                next_state = IDLE;
        end
        START: begin
            if (scl_enable)
                next_state = ADDR;
            else
                next_state = START;
        end
        ADDR: begin
            // Send the slave address and read command
            if (scl_enable)
                next_state = READ_MSB;
            else
                next_state = ADDR;
        end
        READ_MSB: begin
            if (scl_enable)
                next_state = READ_LSB;
            else
                next_state = READ_MSB;
        end
        READ_LSB: begin
            if (scl_enable)
                next_state = STOP;
            else
                next_state = READ_LSB;
        end
        STOP: begin
            if (scl_enable)
                next_state = CONVERT;
            else
                next_state = STOP;
        end
        CONVERT: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Reading temperature and conversion logic
always @(posedge clk) begin
    if (rst) begin
        msb_data <= 8'd0;
        lsb_data <= 8'd0;
        temperature <= 16'd0;
    end else begin
        case (state)
            READ_MSB: begin
                // Capture MSB data from I2C bus
                if (scl_enable)
                    msb_data <= data;
            end
            READ_LSB: begin
                // Capture LSB data from I2C bus
                if (scl_enable)
                    lsb_data <= data;
            end
            CONVERT: begin
                // Combine MSB and LSB, shift and multiply by 0.0625
                temperature <= (({msb_data, lsb_data} >> 3) * 16'd625) / 10000;

                // Split temperature into 4 digits for 7-segment display
                digit1 <= temperature % 10;              // Units place
                digit2 <= (temperature / 10) % 10;       // Tens place
                digit3 <= (temperature / 100) % 10;      // Hundreds place
                digit4 <= (temperature / 1000) % 10;     // Thousands place
            end
        endcase
    end
end

// 7-segment display refresh logic
always @(posedge clk or posedge rst) begin
    if (rst)
        refresh_counter <= 2'b00;
    else
        refresh_counter <= refresh_counter + 1;
end

endmodule

