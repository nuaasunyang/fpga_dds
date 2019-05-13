module dds(
  input              clk,
  input              rst_n,
  input              uart_rx,
  input              direction,

  output    reg        led ,
  output    reg        sin1,
  output    reg        sin2,
  output    reg        cos1,
  output    reg        cos2
);

parameter                        CLK_FRE = 50;//Mhz

wire  sin_1;
wire  sin_2;
wire  cos_1;
wire  cos_2;

wire[7:0]                        rx_data;
wire                             rx_data_valid;
wire                             rx_data_ready;

wire                 clkout1;


reg[8:0]             sin1_addr;
reg[8:0]             sin2_addr;
reg[8:0]             cos1_addr;
reg[8:0]             cos2_addr;
reg[49:0]            fre_word = 50'd3564823;//4150
//reg[31:0]            fre_word = 32'd3650722;//4250
reg[31:0]            phaseadder;

reg[16:0]            pinlv = 17'd43000;
reg[2:0]             wait_cnt = 3'd0;
reg[3:0]             tx_str;

reg[49:0]            para1=50'd858993;
reg[49:0]            p2=50'd1<<32;
reg[49:0]            p3=50'd50_000_000;
//assign  sin1 = sin_1;
//assign  sin2 = sin_2;
//assign  cos1 = cos_1;
//assign  cos2 = cos_2;

assign rx_data_ready = 1'b1; //always can receive data

pll200 pll_inst
(
  .inclk0(clk),
  .c0(clkout1)
);

sin1  sin1_m0(
    .address (sin1_addr),
	 .clock   (clk),
	 .q       (sin_1),
);

sin2  sin2_m0(
    .address (sin2_addr),
	 .clock   (clk),
	 .q       (sin_2),
);

cos1  cos1_m0(
    .address (cos1_addr),
	 .clock   (clk),
	 .q       (cos_1),
);

cos2  cos2_m0(
    .address (cos2_addr),
	 .clock   (clk),
	 .q       (cos_2),
);

uart_rx#
(
	.CLK_FRE(50),
	.BAUD_RATE(115200)
) uart_rx_inst
(
	.clk                        (clk                  ),
	.rst_n                      (rst_n                    ),
	.rx_data                    (rx_data                  ),
	.rx_data_valid              (rx_data_valid            ),
	.rx_data_ready              (rx_data_ready            ),
	.rx_pin                     (uart_rx                  )
);

always@(negedge clk)
begin
	if(rx_data_valid == 1'b1)
	begin
		case(wait_cnt)
		3'd0 :  
		   begin
		   pinlv <= tx_str*10000;
		   wait_cnt <= wait_cnt + 3'd1;		
		   end
		3'd1 :  
		   begin
		   pinlv <= pinlv+tx_str*1000;
		   wait_cnt <= wait_cnt + 3'd1;
		   end
		3'd2 :  
		   begin
		   pinlv <= pinlv+tx_str*100;
			wait_cnt <= wait_cnt + 3'd1;
			end
		3'd3 :  
		   begin
			pinlv <= pinlv+tx_str*10;
			wait_cnt <= wait_cnt + 3'd1;
			end
		3'd4 :
         begin		
		   pinlv <= pinlv+tx_str;

 //        para1 = pinlv *p2;		
//			fre_word = para1/p3; 
//         fre_word <= pinlv*86;
//			led <= ~led;
//			wait_cnt <= 3'd0;
			wait_cnt <= wait_cnt + 3'd1;
//			fre_word <= fre_word-32'd860;
//        fre_word <= pinlv*(33'b1<<32)/(32'd50_000_000);
//			para2 = para1;
//         fre_word = pinlv;
			end
		3'd5 : 
		   begin
//	      para1	= pinlv*85899345;
			para1 = pinlv<<32;
			fre_word = para1 /50_000_000;
		   led <= ~led;
			wait_cnt <= 3'd0;
		   end
		default:
		   begin
		   pinlv = 16'd43000;
		   end
	   endcase	
  end
//	else 
//	   begin
//	   fre_word <=fre_word;
//		end
//    led <= rx_data_valid;	
end

always@(posedge clkout1 )
begin
	case(rx_data)
		8'h30 :  tx_str <= 4'd0;
		8'h31 :  tx_str <= 4'd1;
		8'h32 :  tx_str <= 4'd2;
		8'h33 :  tx_str <= 4'd3;
		8'h34 :  tx_str <= 4'd4;
		8'h35 :  tx_str <= 4'd5;
		8'h36 :  tx_str <= 4'd6;
		8'h37 :  tx_str <= 4'd7;
		8'h38 :  tx_str <= 4'd8;
		8'h39 :  tx_str <= 4'd9;
		default:tx_str <= 4'd0;
	endcase
end

always@(posedge clk)
begin
    if(direction == 0)
	 begin
    phaseadder <= phaseadder + fre_word;
	 sin1_addr <= phaseadder[31:23];
	 sin2_addr <= phaseadder[31:23];	 
    cos1_addr <= phaseadder[31:23];	 
	 cos2_addr <= phaseadder[31:23];
	 sin1 <= sin_1;
	 sin2 <= sin_2;
	 cos1 <= cos_1;
	 cos2 <= cos_2;
	 end
	 else 
	 begin
	 phaseadder <= phaseadder + fre_word;
	 sin1_addr <= phaseadder[31:23];
	 sin2_addr <= phaseadder[31:23];	 
    cos1_addr <= phaseadder[31:23];	 
	 cos2_addr <= phaseadder[31:23];
	 sin1 <= cos_1;
	 sin2 <= cos_2;
	 cos1 <= sin_1;
	 cos2 <= sin_2;
	 end
end

endmodule