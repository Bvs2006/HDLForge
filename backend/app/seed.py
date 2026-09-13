import logging

from sqlalchemy.orm import Session

from app.db.database import SessionLocal
from app.db.models import Difficulty, Language, Problem, TestCase, TestVisibility

logger = logging.getLogger(__name__)


PUBLIC_TESTBENCHES = {
    "and-gate": """\
module testbench;
  logic a, b, y;
  and_gate uut (.a(a), .b(b), .y(y));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp, input string name);
    total_count++;
    if (y === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", y);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 0; b = 0; #1;
    check(1'b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1'b0, "a=0,b=1 -> y=0");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "or-gate": """\
module testbench;
  logic a, b, y;
  or_gate uut (.a(a), .b(b), .y(y));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp, input string name);
    total_count++;
    if (y === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", y);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 0; b = 0; #1;
    check(1'b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1'b1, "a=0,b=1 -> y=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "not-gate": """\
module testbench;
  logic a, y;
  not_gate uut (.a(a), .y(y));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp, input string name);
    total_count++;
    if (y === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", y);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 0; #1;
    check(1'b1, "a=0 -> y=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "xor-gate": """\
module testbench;
  logic a, b, y;
  xor_gate uut (.a(a), .b(b), .y(y));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp, input string name);
    total_count++;
    if (y === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", y);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 0; b = 0; #1;
    check(1'b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1'b1, "a=0,b=1 -> y=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "2-to-1-mux": """\
module testbench;
  logic a, b, sel, y;
  mux2 uut (.a(a), .b(b), .sel(sel), .y(y));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp, input string name);
    total_count++;
    if (y === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", y);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 0; b = 0; sel = 0; #1;
    check(1'b0, "sel=0,a=0,b=0 -> y=0");
    a = 1; b = 0; sel = 0; #1;
    check(1'b1, "sel=0,a=1,b=0 -> y=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "half-adder": """\
module testbench;
  logic a, b, sum, carry;
  half_adder uut (.a(a), .b(b), .sum(sum), .carry(carry));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp_sum, input logic exp_carry, input string name);
    total_count++;
    if (sum === exp_sum && carry === exp_carry) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:sum=%b,carry=%b", exp_sum, exp_carry);
      $display("HDLFORGE_RECEIVED:sum=%b,carry=%b", sum, carry);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 0; b = 0; #1;
    check(1'b0, 1'b0, "0+0 -> sum=0,carry=0");
    a = 0; b = 1; #1;
    check(1'b1, 1'b0, "0+1 -> sum=1,carry=0");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "full-adder": """\
module testbench;
  logic a, b, cin, sum, cout;
  full_adder uut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp_sum, input logic exp_cout, input string name);
    total_count++;
    if (sum === exp_sum && cout === exp_cout) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:sum=%b,cout=%b", exp_sum, exp_cout);
      $display("HDLFORGE_RECEIVED:sum=%b,cout=%b", sum, cout);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 0; b = 0; cin = 0; #1;
    check(1'b0, 1'b0, "0+0+0 -> sum=0,cout=0");
    a = 0; b = 0; cin = 1; #1;
    check(1'b1, 1'b0, "0+0+1 -> sum=1,cout=0");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "d-flip-flop": """\
module testbench;
  logic clk, rst, d, q;
  d_flip_flop uut (.clk(clk), .rst(rst), .d(d), .q(q));
  initial clk = 0;
  always #5 clk = ~clk;
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp, input string name);
    total_count++;
    if (q === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", q);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    rst = 1; d = 0; #12;
    check(1'b0, "reset -> q=0");
    rst = 0; d = 1; #10;
    check(1'b1, "d=1 after posedge -> q=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "4-bit-counter": """\
module testbench;
  logic clk, rst;
  logic [3:0] count;
  counter uut (.clk(clk), .rst(rst), .count(count));
  initial clk = 0;
  always #5 clk = ~clk;
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic [3:0] exp, input string name);
    total_count++;
    if (count === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", count);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    rst = 1; #12;
    check(4'b0000, "reset -> count=0");
    rst = 0; #10;
    check(4'b0001, "count=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "4-bit-alu": """\
module testbench;
  logic [3:0] a, b;
  logic [1:0] op;
  logic [3:0] result;
  alu uut (.a(a), .b(b), .op(op), .result(result));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic [3:0] exp, input string name);
    total_count++;
    if (result === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", result);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 4'b0011; b = 4'b0001; op = 2'b00; #1;
    check(4'b0100, "ADD 3+1=4");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
}

HIDDEN_TESTBENCHES = {
    "and-gate": """\
module testbench;
  logic a, b, y;
  and_gate uut (.a(a), .b(b), .y(y));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp, input string name);
    total_count++;
    if (y === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", y);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 1; b = 0; #1;
    check(1'b0, "a=1,b=0 -> y=0");
    a = 1; b = 1; #1;
    check(1'b1, "a=1,b=1 -> y=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "or-gate": """\
module testbench;
  logic a, b, y;
  or_gate uut (.a(a), .b(b), .y(y));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp, input string name);
    total_count++;
    if (y === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", y);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 1; b = 0; #1;
    check(1'b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1'b1, "a=1,b=1 -> y=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "not-gate": """\
module testbench;
  logic a, y;
  not_gate uut (.a(a), .y(y));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp, input string name);
    total_count++;
    if (y === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", y);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 1; #1;
    check(1'b0, "a=1 -> y=0");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "xor-gate": """\
module testbench;
  logic a, b, y;
  xor_gate uut (.a(a), .b(b), .y(y));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp, input string name);
    total_count++;
    if (y === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", y);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 1; b = 0; #1;
    check(1'b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1'b0, "a=1,b=1 -> y=0");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "2-to-1-mux": """\
module testbench;
  logic a, b, sel, y;
  mux2 uut (.a(a), .b(b), .sel(sel), .y(y));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp, input string name);
    total_count++;
    if (y === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", y);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 0; b = 1; sel = 0; #1;
    check(1'b0, "sel=0,a=0,b=1 -> y=0");
    a = 1; b = 0; sel = 1; #1;
    check(1'b0, "sel=1,a=1,b=0 -> y=0");
    a = 0; b = 1; sel = 1; #1;
    check(1'b1, "sel=1,a=0,b=1 -> y=1");
    a = 1; b = 1; sel = 1; #1;
    check(1'b1, "sel=1,a=1,b=1 -> y=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "half-adder": """\
module testbench;
  logic a, b, sum, carry;
  half_adder uut (.a(a), .b(b), .sum(sum), .carry(carry));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp_sum, input logic exp_carry, input string name);
    total_count++;
    if (sum === exp_sum && carry === exp_carry) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:sum=%b,carry=%b", exp_sum, exp_carry);
      $display("HDLFORGE_RECEIVED:sum=%b,carry=%b", sum, carry);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 1; b = 0; #1;
    check(1'b1, 1'b0, "1+0 -> sum=1,carry=0");
    a = 1; b = 1; #1;
    check(1'b0, 1'b1, "1+1 -> sum=0,carry=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "full-adder": """\
module testbench;
  logic a, b, cin, sum, cout;
  full_adder uut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp_sum, input logic exp_cout, input string name);
    total_count++;
    if (sum === exp_sum && cout === exp_cout) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:sum=%b,cout=%b", exp_sum, exp_cout);
      $display("HDLFORGE_RECEIVED:sum=%b,cout=%b", sum, cout);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 0; b = 1; cin = 0; #1;
    check(1'b1, 1'b0, "0+1+0 -> sum=1,cout=0");
    a = 0; b = 1; cin = 1; #1;
    check(1'b0, 1'b1, "0+1+1 -> sum=0,cout=1");
    a = 1; b = 0; cin = 0; #1;
    check(1'b1, 1'b0, "1+0+0 -> sum=1,cout=0");
    a = 1; b = 0; cin = 1; #1;
    check(1'b0, 1'b1, "1+0+1 -> sum=0,cout=1");
    a = 1; b = 1; cin = 0; #1;
    check(1'b0, 1'b1, "1+1+0 -> sum=0,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1'b1, 1'b1, "1+1+1 -> sum=1,cout=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "d-flip-flop": """\
module testbench;
  logic clk, rst, d, q;
  d_flip_flop uut (.clk(clk), .rst(rst), .d(d), .q(q));
  initial clk = 0;
  always #5 clk = ~clk;
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic exp, input string name);
    total_count++;
    if (q === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", q);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    rst = 0; d = 0; #10;
    check(1'b0, "d=0 after posedge -> q=0");
    d = 0; #10;
    check(1'b0, "d=0 hold -> q=0");
    d = 1; #3; rst = 1; #7;
    check(1'b0, "reset synchronous -> q=0");
    rst = 0; d = 1; #10;
    check(1'b1, "d=1 after reset release -> q=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "4-bit-counter": """\
module testbench;
  logic clk, rst;
  logic [3:0] count;
  counter uut (.clk(clk), .rst(rst), .count(count));
  initial clk = 0;
  always #5 clk = ~clk;
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic [3:0] exp, input string name);
    total_count++;
    if (count === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", count);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    rst = 1; #12;
    check(4'b0000, "reset -> count=0");
    rst = 0; #10;
    check(4'b0001, "count=1");
    #10;
    check(4'b0010, "count=2");
    #10;
    check(4'b0011, "count=3");
    #80;
    check(4'b1011, "count=11");
    repeat(5) #10;
    check(4'b0000, "overflow wrap to 0");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
    "4-bit-alu": """\
module testbench;
  logic [3:0] a, b;
  logic [1:0] op;
  logic [3:0] result;
  alu uut (.a(a), .b(b), .op(op), .result(result));
  int pass_count = 0;
  int total_count = 0;
  task automatic check(input logic [3:0] exp, input string name);
    total_count++;
    if (result === exp) begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_TEST_PASS");
      pass_count++;
    end else begin
      $display("HDLFORGE_TEST_NAME:%s", name);
      $display("HDLFORGE_EXPECTED:%b", exp);
      $display("HDLFORGE_RECEIVED:%b", result);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 4'b0101; b = 4'b0010; op = 2'b01; #1;
    check(4'b0011, "SUB 5-2=3");
    a = 4'b1100; b = 4'b1010; op = 2'b10; #1;
    check(4'b1000, "AND 0xC & 0xA = 0x8");
    a = 4'b1100; b = 4'b1010; op = 2'b11; #1;
    check(4'b1110, "OR 0xC | 0xA = 0xE");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / total_count);
    $finish;
  end
endmodule""",
}

SEED_PROBLEMS = [
    {
        "slug": "and-gate",
        "title": "AND Gate",
        "difficulty": Difficulty.EASY,
        "category": "Combinational Logic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a 2-input AND gate. The output should be 1 only when both inputs are 1.",
        "input_description": "a, b \u2014 single-bit inputs",
        "output_description": "y \u2014 single-bit output",
        "constraints": "Both inputs are single-bit values.",
        "starter_code": "module and_gate (\n  input  logic a,\n  input  logic b,\n  output logic y\n);\n\n  // Your code here\n\nendmodule",
    },
    {
        "slug": "or-gate",
        "title": "OR Gate",
        "difficulty": Difficulty.EASY,
        "category": "Combinational Logic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a 2-input OR gate. The output should be 1 when at least one input is 1.",
        "input_description": "a, b \u2014 single-bit inputs",
        "output_description": "y \u2014 single-bit output",
        "constraints": "Both inputs are single-bit values.",
        "starter_code": "module or_gate (\n  input  logic a,\n  input  logic b,\n  output logic y\n);\n\n  // Your code here\n\nendmodule",
    },
    {
        "slug": "not-gate",
        "title": "NOT Gate",
        "difficulty": Difficulty.EASY,
        "category": "Combinational Logic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a NOT gate (inverter). The output should be the inverse of the input.",
        "input_description": "a \u2014 single-bit input",
        "output_description": "y \u2014 single-bit output",
        "constraints": "Input is a single-bit value.",
        "starter_code": "module not_gate (\n  input  logic a,\n  output logic y\n);\n\n  // Your code here\n\nendmodule",
    },
    {
        "slug": "xor-gate",
        "title": "XOR Gate",
        "difficulty": Difficulty.EASY,
        "category": "Combinational Logic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a 2-input XOR gate. The output should be 1 when the inputs are different.",
        "input_description": "a, b \u2014 single-bit inputs",
        "output_description": "y \u2014 single-bit output",
        "constraints": "Both inputs are single-bit values.",
        "starter_code": "module xor_gate (\n  input  logic a,\n  input  logic b,\n  output logic y\n);\n\n  // Your code here\n\nendmodule",
    },
    {
        "slug": "2-to-1-mux",
        "title": "2:1 Multiplexer",
        "difficulty": Difficulty.EASY,
        "category": "Combinational Logic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a 2-to-1 multiplexer. When sel is 0, output a; when sel is 1, output b.",
        "input_description": "a, b \u2014 single-bit inputs, sel \u2014 select signal",
        "output_description": "y \u2014 single-bit output",
        "constraints": "All inputs are single-bit values.",
        "starter_code": "module mux2 (\n  input  logic a,\n  input  logic b,\n  input  logic sel,\n  output logic y\n);\n\n  // Your code here\n\nendmodule",
    },
    {
        "slug": "half-adder",
        "title": "Half Adder",
        "difficulty": Difficulty.EASY,
        "category": "Arithmetic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a half adder that adds two single-bit inputs producing sum and carry outputs.",
        "input_description": "a, b \u2014 single-bit inputs",
        "output_description": "sum, carry \u2014 single-bit outputs",
        "constraints": "Both inputs are single-bit values.",
        "starter_code": "module half_adder (\n  input  logic a,\n  input  logic b,\n  output logic sum,\n  output logic carry\n);\n\n  // Your code here\n\nendmodule",
    },
    {
        "slug": "full-adder",
        "title": "Full Adder",
        "difficulty": Difficulty.EASY,
        "category": "Arithmetic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a full adder that adds two single-bit inputs plus a carry-in, producing sum and carry-out.",
        "input_description": "a, b \u2014 single-bit inputs, cin \u2014 carry-in",
        "output_description": "sum, cout \u2014 single-bit outputs",
        "constraints": "All inputs are single-bit values.",
        "starter_code": "module full_adder (\n  input  logic a,\n  input  logic b,\n  input  logic cin,\n  output logic sum,\n  output logic cout\n);\n\n  // Your code here\n\nendmodule",
    },
    {
        "slug": "d-flip-flop",
        "title": "D Flip-Flop",
        "difficulty": Difficulty.EASY,
        "category": "Sequential Logic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a positive-edge-triggered D flip-flop. On the rising edge of clk, the output q captures the input d. Reset is synchronous and active high.",
        "input_description": "clk \u2014 clock signal, d \u2014 data input, rst \u2014 synchronous reset",
        "output_description": "q \u2014 registered output",
        "constraints": "Reset is active high and synchronous.",
        "starter_code": "module d_flip_flop (\n  input  logic clk,\n  input  logic rst,\n  input  logic d,\n  output logic q\n);\n\n  // Your code here\n\nendmodule",
    },
    {
        "slug": "4-bit-counter",
        "title": "4-bit Counter",
        "difficulty": Difficulty.MEDIUM,
        "category": "Sequential Logic",
        "language": Language.SYSTEMVERILOG,
        "description": "Design a synchronous 4-bit counter. The counter should reset to 0 when rst is asserted, increment on every rising edge of clk, and wrap from 15 back to 0.",
        "input_description": "clk \u2014 clock signal, rst \u2014 synchronous active-high reset",
        "output_description": "count[3:0] \u2014 4-bit counter output",
        "constraints": "Reset is synchronous and active high. Counter wraps from 15 to 0.",
        "starter_code": "module counter (\n  input  logic        clk,\n  input  logic        rst,\n  output logic [3:0]  count\n);\n\n  always_ff @(posedge clk) begin\n    if (rst)\n      count <= 4'b0000;\n    else\n      count <= count + 1'b1;\n  end\n\nendmodule",
    },
    {
        "slug": "4-bit-alu",
        "title": "ALU",
        "difficulty": Difficulty.MEDIUM,
        "category": "Arithmetic",
        "language": Language.SYSTEMVERILOG,
        "description": "Design a simple 4-bit arithmetic logic unit. The ALU should support addition, subtraction, AND, and OR operations based on a 2-bit opcode.",
        "input_description": "a[3:0], b[3:0] \u2014 operands, op[1:0] \u2014 opcode (00=ADD, 01=SUB, 10=AND, 11=OR)",
        "output_description": "result[3:0] \u2014 operation result",
        "constraints": "All operands are 4-bit values.",
        "starter_code": "module alu (\n  input  logic [3:0] a,\n  input  logic [3:0] b,\n  input  logic [1:0] op,\n  output logic [3:0] result\n);\n\n  // Your code here\n\nendmodule",
    },
]

TEST_CASES_CONFIG = {
    "and-gate": [
        {"name": "a=0,b=0", "visibility": "PUBLIC", "weight": 0.25, "order": 1},
        {"name": "a=0,b=1", "visibility": "PUBLIC", "weight": 0.25, "order": 2},
        {"name": "a=1,b=0", "visibility": "HIDDEN", "weight": 0.25, "order": 3},
        {"name": "a=1,b=1", "visibility": "HIDDEN", "weight": 0.25, "order": 4},
    ],
    "or-gate": [
        {"name": "a=0,b=0", "visibility": "PUBLIC", "weight": 0.25, "order": 1},
        {"name": "a=0,b=1", "visibility": "PUBLIC", "weight": 0.25, "order": 2},
        {"name": "a=1,b=0", "visibility": "HIDDEN", "weight": 0.25, "order": 3},
        {"name": "a=1,b=1", "visibility": "HIDDEN", "weight": 0.25, "order": 4},
    ],
    "not-gate": [
        {"name": "a=0", "visibility": "PUBLIC", "weight": 0.5, "order": 1},
        {"name": "a=1", "visibility": "HIDDEN", "weight": 0.5, "order": 2},
    ],
    "xor-gate": [
        {"name": "a=0,b=0", "visibility": "PUBLIC", "weight": 0.25, "order": 1},
        {"name": "a=0,b=1", "visibility": "PUBLIC", "weight": 0.25, "order": 2},
        {"name": "a=1,b=0", "visibility": "HIDDEN", "weight": 0.25, "order": 3},
        {"name": "a=1,b=1", "visibility": "HIDDEN", "weight": 0.25, "order": 4},
    ],
    "2-to-1-mux": [
        {"name": "sel=0,a=0,b=0", "visibility": "PUBLIC", "weight": 0.125, "order": 1},
        {"name": "sel=0,a=1,b=0", "visibility": "PUBLIC", "weight": 0.125, "order": 2},
        {"name": "sel=0,a=0,b=1", "visibility": "HIDDEN", "weight": 0.125, "order": 3},
        {"name": "sel=1,a=0,b=0", "visibility": "HIDDEN", "weight": 0.125, "order": 4},
        {"name": "sel=1,a=1,b=0", "visibility": "HIDDEN", "weight": 0.125, "order": 5},
        {"name": "sel=1,a=0,b=1", "visibility": "HIDDEN", "weight": 0.125, "order": 6},
        {"name": "sel=1,a=1,b=1", "visibility": "HIDDEN", "weight": 0.125, "order": 7},
        {"name": "sel=0,a=1,b=1", "visibility": "HIDDEN", "weight": 0.125, "order": 8},
    ],
    "half-adder": [
        {"name": "0+0", "visibility": "PUBLIC", "weight": 0.25, "order": 1},
        {"name": "0+1", "visibility": "PUBLIC", "weight": 0.25, "order": 2},
        {"name": "1+0", "visibility": "HIDDEN", "weight": 0.25, "order": 3},
        {"name": "1+1", "visibility": "HIDDEN", "weight": 0.25, "order": 4},
    ],
    "full-adder": [
        {"name": "0+0+0", "visibility": "PUBLIC", "weight": 0.125, "order": 1},
        {"name": "0+0+1", "visibility": "PUBLIC", "weight": 0.125, "order": 2},
        {"name": "0+1+0", "visibility": "HIDDEN", "weight": 0.125, "order": 3},
        {"name": "0+1+1", "visibility": "HIDDEN", "weight": 0.125, "order": 4},
        {"name": "1+0+0", "visibility": "HIDDEN", "weight": 0.125, "order": 5},
        {"name": "1+0+1", "visibility": "HIDDEN", "weight": 0.125, "order": 6},
        {"name": "1+1+0", "visibility": "HIDDEN", "weight": 0.125, "order": 7},
        {"name": "1+1+1", "visibility": "HIDDEN", "weight": 0.125, "order": 8},
    ],
    "d-flip-flop": [
        {"name": "reset", "visibility": "PUBLIC", "weight": 0.25, "order": 1},
        {"name": "d=1 capture", "visibility": "PUBLIC", "weight": 0.25, "order": 2},
        {"name": "d=0 hold", "visibility": "HIDDEN", "weight": 0.25, "order": 3},
        {"name": "reset during operation", "visibility": "HIDDEN", "weight": 0.25, "order": 4},
    ],
    "4-bit-counter": [
        {"name": "reset", "visibility": "PUBLIC", "weight": 0.2, "order": 1},
        {"name": "count=1", "visibility": "PUBLIC", "weight": 0.2, "order": 2},
        {"name": "count=2", "visibility": "HIDDEN", "weight": 0.2, "order": 3},
        {"name": "count=3", "visibility": "HIDDEN", "weight": 0.2, "order": 4},
        {"name": "overflow wrap", "visibility": "HIDDEN", "weight": 0.2, "order": 5},
    ],
    "4-bit-alu": [
        {"name": "ADD 3+1=4", "visibility": "PUBLIC", "weight": 0.25, "order": 1},
        {"name": "SUB 5-2=3", "visibility": "HIDDEN", "weight": 0.25, "order": 2},
        {"name": "AND 0xC & 0xA", "visibility": "HIDDEN", "weight": 0.25, "order": 3},
        {"name": "OR 0xC | 0xA", "visibility": "HIDDEN", "weight": 0.25, "order": 4},
    ],
}


def seed_problems() -> None:
    db = SessionLocal()
    try:
        existing = db.query(Problem).count()
        if existing > 0:
            logger.info("Database already contains %d problems. Updating test cases.", existing)
            for problem_data in SEED_PROBLEMS:
                slug = problem_data["slug"]
                existing_problem = db.query(Problem).filter(Problem.slug == slug).first()
                if existing_problem:
                    _seed_test_cases(db, existing_problem, slug)
            db.commit()
            logger.info("Test cases updated for existing problems.")
            return

        for problem_data in SEED_PROBLEMS:
            slug = problem_data["slug"]
            problem = Problem(**problem_data)
            db.add(problem)
            db.flush()
            _seed_test_cases(db, problem, slug)

        db.commit()
        logger.info("Seeded %d problems with test cases.", len(SEED_PROBLEMS))
    except Exception as e:
        db.rollback()
        logger.error("Error seeding problems: %s", e)
        raise
    finally:
        db.close()


def _seed_test_cases(db: Session, problem: Problem, slug: str) -> None:
    existing_count = db.query(TestCase).filter(TestCase.problem_id == problem.id).count()
    if existing_count > 0:
        return

    configs = TEST_CASES_CONFIG.get(slug, [])
    public_tb = PUBLIC_TESTBENCHES.get(slug, "")
    hidden_tb = HIDDEN_TESTBENCHES.get(slug, "")

    for cfg in configs:
        visibility = TestVisibility.PUBLIC if cfg["visibility"] == "PUBLIC" else TestVisibility.HIDDEN
        tb = public_tb if cfg["visibility"] == "PUBLIC" else hidden_tb

        tc = TestCase(
            problem_id=problem.id,
            name=cfg["name"],
            description="",
            testbench=tb,
            visibility=visibility,
            weight=cfg["weight"],
            execution_order=cfg["order"],
            enabled=True,
        )
        db.add(tc)
