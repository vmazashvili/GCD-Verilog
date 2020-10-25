module baseline_c5gx(
	
		///////// CLOCK /////////
		input CLOCK_125_p, ///LVDS
		
      ///////// SW ///////// 1.2 V ///////
      input [7:0]  SW,
		
		///////// KEY ///////// 1.2 V ///////
      input [1:0]  KEY,
		
      ///////// LEDG ///////// 2.5 V ///////
      output      [7:0]  LEDR
    );
     
	  wire clk, rst, button;
	  wire [7:0] numInput;
	  reg [7:0] leds;

	  assign LEDR [7:0] = leds;
	  assign clk = CLOCK_125_p;
	  assign numInput = SW [7:0];
	  assign button = !KEY[1];
	  assign rst = !KEY[0];
	  
	 reg buttonPrev;
	 assign buttonTrigger = !buttonPrev & button;

    reg [7:0] numA, numB;
    reg [1:0] currentState;
    parameter[1:0] takeFirst = 2'b00, takeSecond = 2'b01, calculate = 2'b10, defState = 2'b11;
    
	 
    always@(posedge clk) begin
			buttonPrev <= button;
			if(rst) begin
				currentState <= defState;
				numA <= 0;
				numB <= 0;
				leds <= 0;
		  end
		  else begin
        case(currentState)
            takeFirst : begin
						if(buttonTrigger) begin
							leds <= 0;
							numA <= numInput[7] == 1 ? ~numInput+1 : numInput; //two's complement conversion
							currentState <= takeSecond;
						end			
            end
				
				takeSecond : begin
					if(buttonTrigger) begin
						numB <= numInput[7] == 1 ? ~numInput+1 : numInput;
						currentState <= calculate; 

					end
            end
				
            calculate : begin 
					if(numA == 0) leds <= numB;
					else if(numB == 0) leds <= numA ;
					else if(numA  == numB) leds <= numA ;
					else if(numA  > numB) numA  <= numA - numB;
					else numB <= numB - numA ;
					if(leds) currentState <= takeFirst;
				end
				
            default begin
					currentState <= takeFirst;
				end
        endcase
		  end	  
			
			
    end
        
endmodule
