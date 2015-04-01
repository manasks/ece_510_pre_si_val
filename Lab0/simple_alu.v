module(clk, reset_n, opcode_valid, opcode, data, done, result, overflow)

input clk;
input reset_n;
input opcode_valid;
input opcode;
input [7:0] data;

output done;
output [7:0] result;
output overflow;

parameter ON = 1'b1;
parameter OFF = 1'b0;

parameter

    RESET   = 4'b0000,
    IDLE    = 4'b0001,
    DATA_A  = 4'b0010,
    DATA_B  = 4'b0011,
    ADD     = 4'b0100,
    SUB     = 4'b0101,
    PAR     = 4'b0110,
    COMP    = 4'b0111,
    DONE    = 4'b1000;

parameter
    ADD     = 2'b00,
    SUB     = 2'b01,
    PAR     = 2'b10,
    COMP    = 2'b11;

reg [3:0] State, NextState;
reg [8:0] Sum_AB;
reg [7:0] A_Data, B_Data;
reg [1:0] opcode_def;

always @(posedge clk,reset_n)
begin
    if(reset_n)
        State = RESET;
    else
        State = NextState;
end

always @(State)
begin

end

always @(State,opcode_valid,opcode)
begin
    case(State)
        RESET:
        begin
            done        = OFF;
            data        = 8'b00000000;
            overflow    = OFF;
        end

        IDLE:
        begin
            done        = OFF;
            data        = 8'b00000000;
            overflow    = OFF;
        end

        DATA_A:
        begin
            done        = OFF;
            data        = 8'b00000000;
            overflow    = OFF;
        end

        DATA_B:
        begin
            done        = OFF;
            data        = 8'b00000000;
            overflow    = OFF;
        end

        ADD:
        begin
            done        = OFF;
            Sum_AB      = A_Data + B_Data;
            data        = Sum_AB[7:0];
            overflow    = Sum_AB[8];
        end

        SUB:
        begin
            done        = OFF;
            data        = 8'b00000000;
            overflow    = OFF;
        end

        PAR:
        begin
            done        = OFF;
            data        = 8'b00000000;
            overflow    = OFF;
        end

        COMP:
        begin
            done        = OFF;
            data        = 8'b00000000;
            overflow    = OFF;
        end

        DONE:
        begin
            done        = OFF;
            data        = 8'b00000000;
            overflow    = OFF;
        end
end
