module fullAdder_1b_bench;

    // Instantiate DUT input / outputs
    reg A, B, C_in;
    wire S, C_out;

    fullAdder_1b iDUT(.A(A), .B(B), .C_in(C_in), .S(S), .C_out(C_out));
    
    wire S_man, C_out_man; // manual checks vars
    assign S_man = A ^ B ^ C_in;
    assign C_out_man = (B & C_in) | (A & C_in) | (A & B);

    initial begin
        // Test 1: 0 0 0
        A = 0;
        B = 0;
        C_in = 0;

        if (S !== S_man && C_out_man !== 0) $display("ERROR TEST 1");
        #5

        // Test 2: 0 0 1
        A = 0;
        B = 0;
        C_in = 1;

        if (S !== S_man && C_out !== C_out_man) $display("ERROR TEST 2");
        #5

        // Test 3: 0 1 0
        A = 0;
        B = 1;
        C_in = 0;

        if (S !== S_man && C_out !== C_out_man) $display("ERROR TEST 3");
        #5

        // Test 4: 0 1 1
        A = 0;
        B = 1;
        C_in = 1;

        if (S !== S_man && C_out !== C_out_man) $display("ERROR TEST 4");
        #5

        // Test 5: 1 0 0
        A = 1;
        B = 0;
        C_in = 0;

        if (S !== S_man && C_out_man !== 0) $display("ERROR TEST 5");
        #5

        // Test 6: 1 0 1
        A = 1;
        B = 0;
        C_in = 1;

        if (S !== S_man && C_out !== C_out_man) $display("ERROR TEST 6");
        #5

        // Test 7: 1 1 0
        A = 1;
        B = 1;
        C_in = 0;

        if (S !== S_man && C_out !== C_out_man) $display("ERROR TEST 7");
        #5

        // Test 8: 1 1 1
        A = 1;
        B = 1;
        C_in = 1;

        if (S !== S_man && C_out !== C_out_man) $display("ERROR TEST 8");
        #5

    	$display("Completed Running ALL Tests!");
    end

endmodule
