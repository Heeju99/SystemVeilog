`timescale 1ns / 1ps

module FIFO(
    input   logic       clk,
    input   logic       reset,
    //write side
    input   logic       wr_en,
    input   logic [7:0] wdata,
    output  logic       full,
    //read sid
    output  logic       empty,
    input   logic       rd_en,
    output  logic [7:0] rdata
    );


    RAM U_RAM(
        .clk(clk),
        .wdata(wdata),
        .wAddr(wr_ptr),
        .wr_en(wr_en & ~full),
        .rdata(rdata),
        .rAddr(rd_ptr)
);

    FIFO_ControlUnit U_FIFO_Controlunit(
        .*
);

endmodule

module RAM(
    input  logic clk,
    input  logic [7:0] wdata,
    input  logic [1:0] wAddr,
    input  logic       wr_en,
    output logic [7:0] rdata,
    output logic [1:0] rAddr
);

    logic [7:0] mem[0:2**2 -1];

    always_ff @(posedge clk) begin
        if(wr_en) mem[wAddr] <= wdata;
    end
    assign rdata = mem[rAddr];
endmodule


module FIFO_ControlUnit(
    input logic clk,
    input logic reset,
    // write side
    output logic [1:0] wr_ptr,
    input  logic       wr_en,
    output logic       full,
    // read side
    output logic [1:0] rd_ptr,
    input  logic       rd_en,
    output logic       empty  
);

    localparam READ = 2'b01, WRITE = 2'b10, READ_WRITE = 2'b11;
    logic [1:0] fifo_state;
    logic [1:0] wr_ptr_reg, wr_ptr_next;
    logic [1:0] rd_ptr_reg, rd_ptr_next;
    logic       empty_reg,  empty_next;
    logic       full_reg,  full_next;

    assign fifo_state = {wr_en, rd_en}; //signal에 따른 state 변화
    assign full = full_reg;
    assign empty = empty_reg;
    assign wr_ptr = wr_ptr_reg;
    assign rd_ptr = rd_ptr_reg;

    always_ff @(posedge clk, posedge reset) begin
        if(reset) begin
            wr_ptr_reg <= 0;
            rd_ptr_reg <= 0;
            empty_reg  <= 1;
            full_reg   <= 0;
        end
        else begin
            wr_ptr_reg <= wr_ptr_next;
            rd_ptr_reg <= rd_ptr_next;
            empty_reg  <= empty_next;
            full_reg   <= full_next;
        end
    end

    always_comb begin
        wr_ptr_next = wr_ptr_reg;
        rd_ptr_next = rd_ptr_reg;
        empty_next  = empty_reg;
        full_next  = full_reg;
        case(fifo_state)
            READ : begin
                if(empty_reg == 1'b0) begin
                    full_next = 1'b0;
                    rd_ptr_next = rd_ptr_reg + 1;
                    if(rd_ptr_next == wr_ptr_reg) begin
                        empty_next = 1'b1;
                    end
                end
            end
            WRITE : begin
                if(full_reg == 1'b0) begin //not full
                    empty_next = 1'b0;
                    wr_ptr_next = wr_ptr_reg + 1;
                    if(wr_ptr_next == rd_ptr_reg) begin
                        full_next = 1'b1;
                    end
                end
            end

            READ_WRITE : begin
                if(empty_reg == 1'b1) begin  //can write only 
                    wr_ptr_next = wr_ptr_reg + 1;
                    empty_next = 1'b0;
                end else if(full_reg == 1'b1) begin //can read only
                    rd_ptr_next = rd_ptr_reg + 1;
                    full_next = 1'b0;
                end else begin //0,0
                    wr_ptr_next = wr_ptr_reg + 1;
                    rd_ptr_next = rd_ptr_reg + 1;
                end

            end
        endcase
    end
endmodule