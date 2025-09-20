// File Name: slave/fifo_design.v
// Description: Asynchronous FIFO design with separate read and write clocks, supporting configurable width and depth.
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//===================================================================================================================================================
module async_fifo (
    input wclk_i, rclk_i, rst_i, wr_en_i, rd_en_i,                  	// Input signals: write clock, read clock, reset, write enable, read enable
    input [`WIDTH-1:0] wdata_i,                                         // Input data for write operation
    output reg [`WIDTH-1:0] rdata_o,                                    // Output data for read operation
    output reg empty_o, full_o, error_o                                	// Status signals: FIFO empty, full, and error
);


    //=====================================|| Internal registers and memory ||===================================
	
    reg [`WIDTH-1:0] mem [`DEPTH-1:0];                                 // FIFO memory array
    reg [`PTR_WIDTH-1:0] wr_ptr, rd_ptr;                               // Write and read pointers
    reg [`PTR_WIDTH-1:0] wr_ptr_rd_clk, rd_ptr_wr_clk;                 // Synchronized pointers for cross-clock domains
    reg wr_toggle_f, rd_toggle_f;                                      // Toggle flags for wrap-around detection
    reg wr_toggle_f_rd_clk, rd_toggle_f_wr_clk;                        // Synchronized toggle flags
    integer i;                                                         // Loop variable for memory initialization

    //==========================|| READ operation: Handles reading from FIFO on read clock ||====================
	
    always @(posedge rclk_i) begin
        if (rst_i == 0) begin                                          // Synchronous reset for read domain
            error_o = 0;                                               // Clear error flag
            if (rd_en_i == 1) begin                                    // Check if read is enabled
                if (empty_o == 1) begin                                // Check for underflow condition
                    $display("ERROR: Reading from EMPTY FIFO");        // Display error message
                    error_o = 1;                                       // Set error flag
                end
                else begin                                             // Valid read operation
                    rdata_o = mem[rd_ptr];                             // Read data from memory
                    if (rd_ptr == `DEPTH-1) begin                      // Check if at last memory location
                        rd_toggle_f = ~rd_toggle_f;                    // Toggle read flag
                        rd_ptr = 0;                                    // Reset read pointer
                    end
                    else begin                                         // Increment read pointer
                        rd_ptr = rd_ptr + 1;
                    end
                end
            end
        end
    end

    // ==================|| WRITE operation: Handles writing to FIFO on write clock ||=======================
	//
    always @(posedge wclk_i) begin
        if (rst_i == 1) begin                                          // Synchronous reset for write domain
            empty_o = 1;                                               // Initialize FIFO as empty
            full_o = 0;                                                // Clear full flag
            error_o = 0;                                               // Clear error flag
            rdata_o = 0;                                               // Clear read data output
            wr_ptr = 0;                                                // Reset write pointer
            rd_ptr = 0;                                                // Reset read pointer
            wr_ptr_rd_clk = 0;                                         // Reset synchronized write pointer
            rd_ptr_wr_clk = 0;                                         // Reset synchronized read pointer
            wr_toggle_f = 0;                                           // Reset write toggle flag
            rd_toggle_f = 0;                                           // Reset read toggle flag
            wr_toggle_f_rd_clk = 0;                                    // Reset synchronized write toggle flag
            rd_toggle_f_wr_clk = 0;                                    // Reset synchronized read toggle flag
            for (i = 0; i < `DEPTH; i = i + 1) begin                   // Initialize memory to zero
                mem[i] = 0;
            end
        end
        else begin                                                 		// Normal operation
            error_o = 0;                                           		// Clear error flag
            if (wr_en_i == 1) begin                                		// Check if write is enabled
                if (full_o == 1) begin                             		// Check for overflow condition
                    $display("ERROR: Writing to FULL FIFO");       		// Display error message
                    error_o = 1;                                   		// Set error flag
                end
                else begin                                         		// Valid write operation
                    mem[wr_ptr] = wdata_i;                         		// Write data to memory
                    if (wr_ptr == `DEPTH-1) begin                  		 // Check if at last memory location
                        wr_toggle_f = ~wr_toggle_f;                		// Toggle write flag
                        wr_ptr = 0;                                		// Reset write pointer
                    end
                    else begin                                     		// Increment write pointer
                        wr_ptr = wr_ptr + 1;
                    end
                end
            end
        end
    end

    //========|| Synchronization: Synchronize read pointer and toggle flag to write clock domain ||==========
	//
    always @(posedge wclk_i) begin
        rd_ptr_wr_clk <= rd_ptr;                                   // Synchronize read pointer
        rd_toggle_f_wr_clk <= rd_toggle_f;                         // Synchronize read toggle flag
    end

    //========|| Synchronization: Synchronize write pointer and toggle flag to read clock domain ||==========
	//
    always @(posedge rclk_i) begin
        wr_ptr_rd_clk <= wr_ptr;                                   // Synchronize write pointer
        wr_toggle_f_rd_clk <= wr_toggle_f;                         // Synchronize write toggle flag
        // Note: This will synthesize to two flip-flops per bit for double synchronization
    end

    //=============|| Generate full condition: Uses signals synchronized to write clock ||===================
	//
    always @(wr_ptr or rd_ptr_wr_clk) begin
        if (wr_ptr == rd_ptr_wr_clk && wr_toggle_f != rd_toggle_f_wr_clk) begin // FIFO is full
            full_o = 1;                                            // Set full flag
        end
        else begin                                                 // FIFO is not full
            full_o = 0;                                            // Clear full flag
        end
    end

    //===============|| Generate empty condition: Uses signals synchronized to read clock ||=================
	//
    always @(rd_ptr or wr_ptr_rd_clk) begin
        if (wr_ptr_rd_clk == rd_ptr && wr_toggle_f_rd_clk == rd_toggle_f) begin // FIFO is empty
            empty_o = 1;                                           // Set empty flag
        end
        else begin                                                 // FIFO is not empty
            empty_o = 0;                                           // Clear empty flag
        end
    end

endmodule
//===================================================================================================================================================
