//------------------------------------------------------------------------------
//
//Module Name:					Dec8b10b_TB.v
//Department:					Xidian University
//Function Description:	        8B/10B解码器测试文件
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana	Verdvana	Verdvana		  			2019-12-15
//
//-----------------------------------------------------------------------------------
//
//Version	Modified History
//V1.0		基于LUT的8B/10B解码器；
//          一个时钟周期出结果；
//          判断是否为控制信号；
//          判断RD错误；
//          判断解码错误。
//
//-----------------------------------------------------------------------------------


`timescale 1ns/1ns

module Dec8b10b_TB;
	
	reg clk;
	reg rst_n;
	
	reg init_rd_n;
	reg init_rd_val;
	
	reg enable;
	
	reg [9:0] data_in;

	reg [9:0] cnt;
	
	
	wire rd;
	wire k_char;
	
	wire [7:0] data_out;
	wire error;
	wire rd_err;
	wire code_err;

	Dec8b10b u_Dec8b10b(
		//********时钟与复位*********//
		.clk,        //时钟
		.rst_n,      //异步复位
		//***运行不一致性（RD）信号***//
		.init_rd_n,  //RD初始化，通常为0
		.init_rd_val(rd),//RD输入，连接上次转码的RD输出
		.rd,         //RD输出，连接下次转码的RD输入
		//*******控制/数据信号*******//
		.enable,     //使能
		.k_char,     //是否为控制信号输出
		//********数据输入输出*******//
		.data_in(cnt),//10bit待解码数据输入
		.data_out,   //解码后8bit数据输出
		//********错误指示信号*******//
		.error,      //解码或RD错误
		.rd_err,     //RD错误
		.code_err    //解码错误
	);

	initial begin
		clk <= '0;
		forever #10 clk <= ~clk; 
	end


	always_ff @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			cnt <= '0;
		end
		else begin
			cnt <= cnt + 1;
		end
	end
	
	task task_init;
	begin
		rst_n = '0;
		init_rd_n = '0;
		init_rd_val = '0;
		enable = '0;
		data_in = '0;
	end
	endtask

	reg  flag;

	always_ff @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			flag <= '0;
		end
		else if(cnt == 10'b1111111111) begin
			$stop;
		end
		else begin
			flag <= flag;
		end
	end


	initial begin
		task_init;
		#10;
		rst_n = '1;

		#20;
		enable <= 1;
	end
	
endmodule