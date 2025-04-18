`timescale 1ns / 1ps

module RV32I_Core (
    input logic clk,
    input logic reset,
    input logic [31:0] instrCode,
    output logic [31:0] instrMemAddr,
    output logic        dataWe,
    output logic [31:0] dataAddr,
    output logic [31:0] dataWData,
    //additional
    input logic [31:0] dataRData
);
    //하위 인스턴스끼리 동일한 wire 빼내기기
    logic       regFileWe;
    logic [3:0] aluControl;
    logic       aluSrcMuxSel;
    logic       RFWDSrcMuxSel;

    ControlUnit U_ControlUnit (.*);
    DataPath U_DataPath (.*);

endmodule
