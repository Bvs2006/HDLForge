-- ============================================================
-- HDLForge — Supabase Seed Data SQL
-- ============================================================
-- Run this in the Supabase SQL Editor after running supabase_migration.sql
-- ============================================================

-- 1. PROBLEMS
INSERT INTO public.problems (id, slug, title, description, difficulty, category, language, input_description, output_description, constraints, starter_code, time_limit_seconds, memory_limit_mb)
VALUES (1, 'and-gate', 'AND Gate', 'Implement a 2-input AND gate. The output should be 1 only when both inputs are 1.', 'EASY', 'Combinational Logic', 'SYSTEMVERILOG', 'a, b — single-bit inputs', 'y — single-bit output', 'Both inputs are single-bit values.', 'module and_gate (
  input  logic a,
  input  logic b,
  output logic y
);

  // Your code here

endmodule', 5, 256)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  starter_code = EXCLUDED.starter_code;
INSERT INTO public.problems (id, slug, title, description, difficulty, category, language, input_description, output_description, constraints, starter_code, time_limit_seconds, memory_limit_mb)
VALUES (2, 'or-gate', 'OR Gate', 'Implement a 2-input OR gate. The output should be 1 when at least one input is 1.', 'EASY', 'Combinational Logic', 'SYSTEMVERILOG', 'a, b — single-bit inputs', 'y — single-bit output', 'Both inputs are single-bit values.', 'module or_gate (
  input  logic a,
  input  logic b,
  output logic y
);

  // Your code here

endmodule', 5, 256)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  starter_code = EXCLUDED.starter_code;
INSERT INTO public.problems (id, slug, title, description, difficulty, category, language, input_description, output_description, constraints, starter_code, time_limit_seconds, memory_limit_mb)
VALUES (3, 'not-gate', 'NOT Gate', 'Implement a NOT gate (inverter). The output should be the inverse of the input.', 'EASY', 'Combinational Logic', 'SYSTEMVERILOG', 'a — single-bit input', 'y — single-bit output', 'Input is a single-bit value.', 'module not_gate (
  input  logic a,
  output logic y
);

  // Your code here

endmodule', 5, 256)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  starter_code = EXCLUDED.starter_code;
INSERT INTO public.problems (id, slug, title, description, difficulty, category, language, input_description, output_description, constraints, starter_code, time_limit_seconds, memory_limit_mb)
VALUES (4, 'xor-gate', 'XOR Gate', 'Implement a 2-input XOR gate. The output should be 1 when the inputs are different.', 'EASY', 'Combinational Logic', 'SYSTEMVERILOG', 'a, b — single-bit inputs', 'y — single-bit output', 'Both inputs are single-bit values.', 'module xor_gate (
  input  logic a,
  input  logic b,
  output logic y
);

  // Your code here

endmodule', 5, 256)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  starter_code = EXCLUDED.starter_code;
INSERT INTO public.problems (id, slug, title, description, difficulty, category, language, input_description, output_description, constraints, starter_code, time_limit_seconds, memory_limit_mb)
VALUES (5, '2-to-1-mux', '2:1 Multiplexer', 'Implement a 2-to-1 multiplexer. When sel is 0, output a; when sel is 1, output b.', 'EASY', 'Combinational Logic', 'SYSTEMVERILOG', 'a, b — single-bit inputs, sel — select signal', 'y — single-bit output', 'All inputs are single-bit values.', 'module mux2 (
  input  logic a,
  input  logic b,
  input  logic sel,
  output logic y
);

  // Your code here

endmodule', 5, 256)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  starter_code = EXCLUDED.starter_code;
INSERT INTO public.problems (id, slug, title, description, difficulty, category, language, input_description, output_description, constraints, starter_code, time_limit_seconds, memory_limit_mb)
VALUES (6, 'half-adder', 'Half Adder', 'Implement a half adder that adds two single-bit inputs producing sum and carry outputs.', 'EASY', 'Arithmetic', 'SYSTEMVERILOG', 'a, b — single-bit inputs', 'sum, carry — single-bit outputs', 'Both inputs are single-bit values.', 'module half_adder (
  input  logic a,
  input  logic b,
  output logic sum,
  output logic carry
);

  // Your code here

endmodule', 5, 256)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  starter_code = EXCLUDED.starter_code;
INSERT INTO public.problems (id, slug, title, description, difficulty, category, language, input_description, output_description, constraints, starter_code, time_limit_seconds, memory_limit_mb)
VALUES (7, 'full-adder', 'Full Adder', 'Implement a full adder that adds two single-bit inputs plus a carry-in, producing sum and carry-out.', 'EASY', 'Arithmetic', 'SYSTEMVERILOG', 'a, b — single-bit inputs, cin — carry-in', 'sum, cout — single-bit outputs', 'All inputs are single-bit values.', 'module full_adder (
  input  logic a,
  input  logic b,
  input  logic cin,
  output logic sum,
  output logic cout
);

  // Your code here

endmodule', 5, 256)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  starter_code = EXCLUDED.starter_code;
INSERT INTO public.problems (id, slug, title, description, difficulty, category, language, input_description, output_description, constraints, starter_code, time_limit_seconds, memory_limit_mb)
VALUES (8, 'd-flip-flop', 'D Flip-Flop', 'Implement a positive-edge-triggered D flip-flop. On the rising edge of clk, the output q captures the input d. Reset is synchronous and active high.', 'EASY', 'Sequential Logic', 'SYSTEMVERILOG', 'clk — clock signal, d — data input, rst — synchronous reset', 'q — registered output', 'Reset is active high and synchronous.', 'module d_flip_flop (
  input  logic clk,
  input  logic rst,
  input  logic d,
  output logic q
);

  // Your code here

endmodule', 5, 256)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  starter_code = EXCLUDED.starter_code;
INSERT INTO public.problems (id, slug, title, description, difficulty, category, language, input_description, output_description, constraints, starter_code, time_limit_seconds, memory_limit_mb)
VALUES (9, '4-bit-counter', '4-bit Counter', 'Design a synchronous 4-bit counter. The counter should reset to 0 when rst is asserted, increment on every rising edge of clk, and wrap from 15 back to 0.', 'MEDIUM', 'Sequential Logic', 'SYSTEMVERILOG', 'clk — clock signal, rst — synchronous active-high reset', 'count[3:0] — 4-bit counter output', 'Reset is synchronous and active high. Counter wraps from 15 to 0.', 'module counter (
  input  logic        clk,
  input  logic        rst,
  output logic [3:0]  count
);

  always_ff @(posedge clk) begin
    if (rst)
      count <= 4''b0000;
    else
      count <= count + 1''b1;
  end

endmodule', 5, 256)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  starter_code = EXCLUDED.starter_code;
INSERT INTO public.problems (id, slug, title, description, difficulty, category, language, input_description, output_description, constraints, starter_code, time_limit_seconds, memory_limit_mb)
VALUES (10, '4-bit-alu', 'ALU', 'Design a simple 4-bit arithmetic logic unit. The ALU should support addition, subtraction, AND, and OR operations based on a 2-bit opcode.', 'MEDIUM', 'Arithmetic', 'SYSTEMVERILOG', 'a[3:0], b[3:0] — operands, op[1:0] — opcode (00=ADD, 01=SUB, 10=AND, 11=OR)', 'result[3:0] — operation result', 'All operands are 4-bit values.', 'module alu (
  input  logic [3:0] a,
  input  logic [3:0] b,
  input  logic [1:0] op,
  output logic [3:0] result
);

  // Your code here

endmodule', 5, 256)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  starter_code = EXCLUDED.starter_code;

-- Reset problem identity sequence
SELECT setval(pg_get_serial_sequence('public.problems', 'id'), COALESCE(MAX(id), 1)) FROM public.problems;

-- 2. TEST CASES
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (1, 1, 'vectors 1-3 (basic)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 1, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (2, 1, 'vectors 1-3 (verify)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 2, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (3, 1, 'vectors 1-10 (full)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0 (repeat)");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 3, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (4, 1, 'vectors 1-10 (repeat)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0 (repeat)");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 4, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (5, 1, 'vectors 1-10 (edge)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0 (repeat)");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 5, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (6, 1, 'vectors 1-10 (stress)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0 (repeat)");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 6, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (7, 1, 'vectors 1-10 (final-a)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0 (repeat)");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 7, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (8, 1, 'vectors 1-10 (final-b)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0 (repeat)");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 8, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (9, 1, 'vectors 1-10 (final-c)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0 (repeat)");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 9, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (10, 1, 'vectors 1-10 (final-d)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b0, "a=0,b=1 -> y=0 (repeat)");
    a = 1; b = 0; #1;
    check(1''b0, "a=1,b=0 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 10, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (11, 2, 'vectors 1-3 (basic)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 1, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (12, 2, 'vectors 1-3 (verify)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 2, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (13, 2, 'vectors 1-10 (full)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 3, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (14, 2, 'vectors 1-10 (repeat)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 4, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (15, 2, 'vectors 1-10 (edge)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 5, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (16, 2, 'vectors 1-10 (stress)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 6, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (17, 2, 'vectors 1-10 (final-a)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 7, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (18, 2, 'vectors 1-10 (final-b)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 8, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (19, 2, 'vectors 1-10 (final-c)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 9, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (20, 2, 'vectors 1-10 (final-d)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b1, "a=1,b=1 -> y=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 10, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (21, 3, 'vectors 1-3 (basic)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b1, "a=0 -> y=1");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (repeat)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 1, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (22, 3, 'vectors 1-3 (verify)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b1, "a=0 -> y=1");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (repeat)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 2, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (23, 3, 'vectors 1-10 (full)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b1, "a=0 -> y=1");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (edge)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (edge)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (boundary)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (boundary)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 3, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (24, 3, 'vectors 1-10 (repeat)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b1, "a=0 -> y=1");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (edge)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (edge)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (boundary)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (boundary)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 4, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (25, 3, 'vectors 1-10 (edge)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b1, "a=0 -> y=1");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (edge)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (edge)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (boundary)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (boundary)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 5, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (26, 3, 'vectors 1-10 (stress)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b1, "a=0 -> y=1");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (edge)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (edge)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (boundary)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (boundary)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 6, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (27, 3, 'vectors 1-10 (final-a)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b1, "a=0 -> y=1");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (edge)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (edge)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (boundary)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (boundary)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 7, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (28, 3, 'vectors 1-10 (final-b)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b1, "a=0 -> y=1");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (edge)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (edge)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (boundary)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (boundary)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 8, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (29, 3, 'vectors 1-10 (final-c)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b1, "a=0 -> y=1");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (edge)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (edge)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (boundary)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (boundary)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 9, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (30, 3, 'vectors 1-10 (final-d)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b1, "a=0 -> y=1");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (repeat)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (edge)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (edge)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (final)");
    a = 0; #1;
    check(1''b1, "a=0 -> y=1 (boundary)");
    a = 1; #1;
    check(1''b0, "a=1 -> y=0 (boundary)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 10, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (31, 4, 'vectors 1-3 (basic)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 1, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (32, 4, 'vectors 1-3 (verify)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 2, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (33, 4, 'vectors 1-10 (full)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 3, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (34, 4, 'vectors 1-10 (repeat)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 4, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (35, 4, 'vectors 1-10 (edge)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 5, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (36, 4, 'vectors 1-10 (stress)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 6, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (37, 4, 'vectors 1-10 (final-a)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 7, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (38, 4, 'vectors 1-10 (final-b)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 8, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (39, 4, 'vectors 1-10 (final-c)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 9, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (40, 4, 'vectors 1-10 (final-d)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "a=0,b=0 -> y=0");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0");
    a = 1; b = 0; #1;
    check(1''b1, "a=1,b=0 -> y=1 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, "a=0,b=1 -> y=1 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, "a=1,b=1 -> y=0 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, "a=0,b=0 -> y=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 10, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (41, 5, 'vectors 1-3 (basic)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "sel=0,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 0; #1;
    check(1''b0, "sel=0,a=0,b=1 -> y=0");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 1, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (42, 5, 'vectors 1-3 (verify)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "sel=0,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 0; #1;
    check(1''b0, "sel=0,a=0,b=1 -> y=0");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 2, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (43, 5, 'vectors 1-10 (full)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "sel=0,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 0; #1;
    check(1''b0, "sel=0,a=0,b=1 -> y=0");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1");
    a = 1; b = 1; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=1 -> y=1");
    a = 0; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1");
    a = 1; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=1,b=0 -> y=0");
    a = 1; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=1,b=1 -> y=1");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1 (edge)");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 3, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (44, 5, 'vectors 1-10 (repeat)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "sel=0,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 0; #1;
    check(1''b0, "sel=0,a=0,b=1 -> y=0");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1");
    a = 1; b = 1; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=1 -> y=1");
    a = 0; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1");
    a = 1; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=1,b=0 -> y=0");
    a = 1; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=1,b=1 -> y=1");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1 (edge)");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 4, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (45, 5, 'vectors 1-10 (edge)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "sel=0,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 0; #1;
    check(1''b0, "sel=0,a=0,b=1 -> y=0");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1");
    a = 1; b = 1; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=1 -> y=1");
    a = 0; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1");
    a = 1; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=1,b=0 -> y=0");
    a = 1; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=1,b=1 -> y=1");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1 (edge)");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 5, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (46, 5, 'vectors 1-10 (stress)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "sel=0,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 0; #1;
    check(1''b0, "sel=0,a=0,b=1 -> y=0");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1");
    a = 1; b = 1; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=1 -> y=1");
    a = 0; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1");
    a = 1; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=1,b=0 -> y=0");
    a = 1; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=1,b=1 -> y=1");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1 (edge)");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 6, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (47, 5, 'vectors 1-10 (final-a)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "sel=0,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 0; #1;
    check(1''b0, "sel=0,a=0,b=1 -> y=0");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1");
    a = 1; b = 1; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=1 -> y=1");
    a = 0; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1");
    a = 1; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=1,b=0 -> y=0");
    a = 1; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=1,b=1 -> y=1");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1 (edge)");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 7, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (48, 5, 'vectors 1-10 (final-b)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "sel=0,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 0; #1;
    check(1''b0, "sel=0,a=0,b=1 -> y=0");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1");
    a = 1; b = 1; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=1 -> y=1");
    a = 0; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1");
    a = 1; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=1,b=0 -> y=0");
    a = 1; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=1,b=1 -> y=1");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1 (edge)");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 8, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (49, 5, 'vectors 1-10 (final-c)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "sel=0,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 0; #1;
    check(1''b0, "sel=0,a=0,b=1 -> y=0");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1");
    a = 1; b = 1; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=1 -> y=1");
    a = 0; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1");
    a = 1; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=1,b=0 -> y=0");
    a = 1; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=1,b=1 -> y=1");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1 (edge)");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 9, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (50, 5, 'vectors 1-10 (final-d)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, "sel=0,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 0; #1;
    check(1''b0, "sel=0,a=0,b=1 -> y=0");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1");
    a = 1; b = 1; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=1 -> y=1");
    a = 0; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=0,b=0 -> y=0");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1");
    a = 1; b = 0; sel = 1; #1;
    check(1''b0, "sel=1,a=1,b=0 -> y=0");
    a = 1; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=1,b=1 -> y=1");
    a = 1; b = 0; sel = 0; #1;
    check(1''b1, "sel=0,a=1,b=0 -> y=1 (edge)");
    a = 0; b = 1; sel = 1; #1;
    check(1''b1, "sel=1,a=0,b=1 -> y=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 10, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (51, 6, 'vectors 1-3 (basic)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 1, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (52, 6, 'vectors 1-3 (verify)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 2, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (53, 6, 'vectors 1-10 (full)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 3, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (54, 6, 'vectors 1-10 (repeat)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 4, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (55, 6, 'vectors 1-10 (edge)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 5, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (56, 6, 'vectors 1-10 (stress)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 6, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (57, 6, 'vectors 1-10 (final-a)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 7, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (58, 6, 'vectors 1-10 (final-b)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 8, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (59, 6, 'vectors 1-10 (final-c)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 9, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (60, 6, 'vectors 1-10 (final-d)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (repeat)");
    a = 1; b = 0; #1;
    check(1''b1, 1''b0, "1+0 -> sum=1,carry=0 (repeat)");
    a = 0; b = 1; #1;
    check(1''b1, 1''b0, "0+1 -> sum=1,carry=0 (repeat)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (repeat)");
    a = 1; b = 1; #1;
    check(1''b0, 1''b1, "1+1 -> sum=0,carry=1 (edge)");
    a = 0; b = 0; #1;
    check(1''b0, 1''b0, "0+0 -> sum=0,carry=0 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 10, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (61, 7, 'vectors 1-3 (basic)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0+0 -> sum=0,cout=0");
    a = 0; b = 0; cin = 1; #1;
    check(1''b1, 1''b0, "0+0+1 -> sum=1,cout=0");
    a = 0; b = 1; cin = 0; #1;
    check(1''b1, 1''b0, "0+1+0 -> sum=1,cout=0");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 1, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (62, 7, 'vectors 1-3 (verify)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0+0 -> sum=0,cout=0");
    a = 0; b = 0; cin = 1; #1;
    check(1''b1, 1''b0, "0+0+1 -> sum=1,cout=0");
    a = 0; b = 1; cin = 0; #1;
    check(1''b1, 1''b0, "0+1+0 -> sum=1,cout=0");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 2, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (63, 7, 'vectors 1-10 (full)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0+0 -> sum=0,cout=0");
    a = 0; b = 0; cin = 1; #1;
    check(1''b1, 1''b0, "0+0+1 -> sum=1,cout=0");
    a = 0; b = 1; cin = 0; #1;
    check(1''b1, 1''b0, "0+1+0 -> sum=1,cout=0");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1");
    a = 1; b = 0; cin = 0; #1;
    check(1''b1, 1''b0, "1+0+0 -> sum=1,cout=0");
    a = 1; b = 0; cin = 1; #1;
    check(1''b0, 1''b1, "1+0+1 -> sum=0,cout=1");
    a = 1; b = 1; cin = 0; #1;
    check(1''b0, 1''b1, "1+1+0 -> sum=0,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1 (repeat)");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 3, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (64, 7, 'vectors 1-10 (repeat)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0+0 -> sum=0,cout=0");
    a = 0; b = 0; cin = 1; #1;
    check(1''b1, 1''b0, "0+0+1 -> sum=1,cout=0");
    a = 0; b = 1; cin = 0; #1;
    check(1''b1, 1''b0, "0+1+0 -> sum=1,cout=0");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1");
    a = 1; b = 0; cin = 0; #1;
    check(1''b1, 1''b0, "1+0+0 -> sum=1,cout=0");
    a = 1; b = 0; cin = 1; #1;
    check(1''b0, 1''b1, "1+0+1 -> sum=0,cout=1");
    a = 1; b = 1; cin = 0; #1;
    check(1''b0, 1''b1, "1+1+0 -> sum=0,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1 (repeat)");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 4, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (65, 7, 'vectors 1-10 (edge)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0+0 -> sum=0,cout=0");
    a = 0; b = 0; cin = 1; #1;
    check(1''b1, 1''b0, "0+0+1 -> sum=1,cout=0");
    a = 0; b = 1; cin = 0; #1;
    check(1''b1, 1''b0, "0+1+0 -> sum=1,cout=0");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1");
    a = 1; b = 0; cin = 0; #1;
    check(1''b1, 1''b0, "1+0+0 -> sum=1,cout=0");
    a = 1; b = 0; cin = 1; #1;
    check(1''b0, 1''b1, "1+0+1 -> sum=0,cout=1");
    a = 1; b = 1; cin = 0; #1;
    check(1''b0, 1''b1, "1+1+0 -> sum=0,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1 (repeat)");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 5, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (66, 7, 'vectors 1-10 (stress)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0+0 -> sum=0,cout=0");
    a = 0; b = 0; cin = 1; #1;
    check(1''b1, 1''b0, "0+0+1 -> sum=1,cout=0");
    a = 0; b = 1; cin = 0; #1;
    check(1''b1, 1''b0, "0+1+0 -> sum=1,cout=0");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1");
    a = 1; b = 0; cin = 0; #1;
    check(1''b1, 1''b0, "1+0+0 -> sum=1,cout=0");
    a = 1; b = 0; cin = 1; #1;
    check(1''b0, 1''b1, "1+0+1 -> sum=0,cout=1");
    a = 1; b = 1; cin = 0; #1;
    check(1''b0, 1''b1, "1+1+0 -> sum=0,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1 (repeat)");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 6, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (67, 7, 'vectors 1-10 (final-a)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0+0 -> sum=0,cout=0");
    a = 0; b = 0; cin = 1; #1;
    check(1''b1, 1''b0, "0+0+1 -> sum=1,cout=0");
    a = 0; b = 1; cin = 0; #1;
    check(1''b1, 1''b0, "0+1+0 -> sum=1,cout=0");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1");
    a = 1; b = 0; cin = 0; #1;
    check(1''b1, 1''b0, "1+0+0 -> sum=1,cout=0");
    a = 1; b = 0; cin = 1; #1;
    check(1''b0, 1''b1, "1+0+1 -> sum=0,cout=1");
    a = 1; b = 1; cin = 0; #1;
    check(1''b0, 1''b1, "1+1+0 -> sum=0,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1 (repeat)");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 7, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (68, 7, 'vectors 1-10 (final-b)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0+0 -> sum=0,cout=0");
    a = 0; b = 0; cin = 1; #1;
    check(1''b1, 1''b0, "0+0+1 -> sum=1,cout=0");
    a = 0; b = 1; cin = 0; #1;
    check(1''b1, 1''b0, "0+1+0 -> sum=1,cout=0");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1");
    a = 1; b = 0; cin = 0; #1;
    check(1''b1, 1''b0, "1+0+0 -> sum=1,cout=0");
    a = 1; b = 0; cin = 1; #1;
    check(1''b0, 1''b1, "1+0+1 -> sum=0,cout=1");
    a = 1; b = 1; cin = 0; #1;
    check(1''b0, 1''b1, "1+1+0 -> sum=0,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1 (repeat)");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 8, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (69, 7, 'vectors 1-10 (final-c)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0+0 -> sum=0,cout=0");
    a = 0; b = 0; cin = 1; #1;
    check(1''b1, 1''b0, "0+0+1 -> sum=1,cout=0");
    a = 0; b = 1; cin = 0; #1;
    check(1''b1, 1''b0, "0+1+0 -> sum=1,cout=0");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1");
    a = 1; b = 0; cin = 0; #1;
    check(1''b1, 1''b0, "1+0+0 -> sum=1,cout=0");
    a = 1; b = 0; cin = 1; #1;
    check(1''b0, 1''b1, "1+0+1 -> sum=0,cout=1");
    a = 1; b = 1; cin = 0; #1;
    check(1''b0, 1''b1, "1+1+0 -> sum=0,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1 (repeat)");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 9, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (70, 7, 'vectors 1-10 (final-d)', 'Phase 9B comprehensive test', 'module testbench;
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
    check(1''b0, 1''b0, "0+0+0 -> sum=0,cout=0");
    a = 0; b = 0; cin = 1; #1;
    check(1''b1, 1''b0, "0+0+1 -> sum=1,cout=0");
    a = 0; b = 1; cin = 0; #1;
    check(1''b1, 1''b0, "0+1+0 -> sum=1,cout=0");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1");
    a = 1; b = 0; cin = 0; #1;
    check(1''b1, 1''b0, "1+0+0 -> sum=1,cout=0");
    a = 1; b = 0; cin = 1; #1;
    check(1''b0, 1''b1, "1+0+1 -> sum=0,cout=1");
    a = 1; b = 1; cin = 0; #1;
    check(1''b0, 1''b1, "1+1+0 -> sum=0,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1");
    a = 1; b = 1; cin = 1; #1;
    check(1''b1, 1''b1, "1+1+1 -> sum=1,cout=1 (repeat)");
    a = 0; b = 1; cin = 1; #1;
    check(1''b0, 1''b1, "0+1+1 -> sum=0,cout=1 (edge)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 10, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (71, 8, 'vectors 1-3 (basic)', 'Phase 9B comprehensive test', 'module testbench;
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
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (rst overrides)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 1, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (72, 8, 'vectors 1-3 (verify)', 'Phase 9B comprehensive test', 'module testbench;
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
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (rst overrides)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 2, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (73, 8, 'vectors 1-10 (full)', 'Phase 9B comprehensive test', 'module testbench;
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
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (rst overrides)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (toggle)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (toggle)");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (reset mid-op)");
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0 (reset hold)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (after reset)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (final)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 3, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (74, 8, 'vectors 1-10 (repeat)', 'Phase 9B comprehensive test', 'module testbench;
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
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (rst overrides)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (toggle)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (toggle)");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (reset mid-op)");
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0 (reset hold)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (after reset)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (final)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 4, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (75, 8, 'vectors 1-10 (edge)', 'Phase 9B comprehensive test', 'module testbench;
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
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (rst overrides)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (toggle)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (toggle)");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (reset mid-op)");
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0 (reset hold)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (after reset)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (final)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 5, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (76, 8, 'vectors 1-10 (stress)', 'Phase 9B comprehensive test', 'module testbench;
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
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (rst overrides)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (toggle)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (toggle)");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (reset mid-op)");
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0 (reset hold)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (after reset)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (final)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 6, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (77, 8, 'vectors 1-10 (final-a)', 'Phase 9B comprehensive test', 'module testbench;
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
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (rst overrides)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (toggle)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (toggle)");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (reset mid-op)");
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0 (reset hold)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (after reset)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (final)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 7, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (78, 8, 'vectors 1-10 (final-b)', 'Phase 9B comprehensive test', 'module testbench;
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
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (rst overrides)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (toggle)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (toggle)");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (reset mid-op)");
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0 (reset hold)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (after reset)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (final)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 8, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (79, 8, 'vectors 1-10 (final-c)', 'Phase 9B comprehensive test', 'module testbench;
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
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (rst overrides)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (toggle)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (toggle)");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (reset mid-op)");
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0 (reset hold)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (after reset)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (final)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 9, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (80, 8, 'vectors 1-10 (final-d)', 'Phase 9B comprehensive test', 'module testbench;
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
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (rst overrides)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (toggle)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (toggle)");
    rst = 1; d = 1; #10;
    check(1''b0, "rst=1,d=1 -> q=0 (reset mid-op)");
    rst = 1; d = 0; #10;
    check(1''b0, "rst=1,d=0 -> q=0 (reset hold)");
    rst = 0; d = 1; #10;
    check(1''b1, "rst=0,d=1 -> q=1 (after reset)");
    rst = 0; d = 0; #10;
    check(1''b0, "rst=0,d=0 -> q=0 (final)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 10, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (81, 9, 'vectors 1-3 (basic)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", count, count);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    rst = 1; #12;
    check(4''b0000, "rst -> count=0");
    #10;
    check(4''d1, "count=1");
    #10;
    check(4''d2, "count=2");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 1, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (82, 9, 'vectors 1-3 (verify)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", count, count);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    rst = 1; #12;
    check(4''b0000, "rst -> count=0");
    #10;
    check(4''d1, "count=1");
    #10;
    check(4''d2, "count=2");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 2, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (83, 9, 'vectors 1-10 (full)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", count, count);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    rst = 1; #12;
    check(4''b0000, "rst -> count=0");
    #10;
    check(4''d1, "count=1");
    #10;
    check(4''d2, "count=2");
    #10;
    check(4''d3, "count=3");
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    check(4''d14, "count=14 (near max)");
    #10;
    check(4''d15, "count=15 (max)");
    #10;
    check(4''d0, "count=0 (wrap from 15)");
    #10;
    check(4''d1, "count=1 (after wrap)");
    rst = 1; #12;
    check(4''b0000, "rst after counting -> count=0");
    #10;
    check(4''d1, "count=1 (resume after reset)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 3, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (84, 9, 'vectors 1-10 (repeat)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", count, count);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    rst = 1; #12;
    check(4''b0000, "rst -> count=0");
    #10;
    check(4''d1, "count=1");
    #10;
    check(4''d2, "count=2");
    #10;
    check(4''d3, "count=3");
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    check(4''d14, "count=14 (near max)");
    #10;
    check(4''d15, "count=15 (max)");
    #10;
    check(4''d0, "count=0 (wrap from 15)");
    #10;
    check(4''d1, "count=1 (after wrap)");
    rst = 1; #12;
    check(4''b0000, "rst after counting -> count=0");
    #10;
    check(4''d1, "count=1 (resume after reset)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 4, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (85, 9, 'vectors 1-10 (edge)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", count, count);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    rst = 1; #12;
    check(4''b0000, "rst -> count=0");
    #10;
    check(4''d1, "count=1");
    #10;
    check(4''d2, "count=2");
    #10;
    check(4''d3, "count=3");
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    check(4''d14, "count=14 (near max)");
    #10;
    check(4''d15, "count=15 (max)");
    #10;
    check(4''d0, "count=0 (wrap from 15)");
    #10;
    check(4''d1, "count=1 (after wrap)");
    rst = 1; #12;
    check(4''b0000, "rst after counting -> count=0");
    #10;
    check(4''d1, "count=1 (resume after reset)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 5, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (86, 9, 'vectors 1-10 (stress)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", count, count);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    rst = 1; #12;
    check(4''b0000, "rst -> count=0");
    #10;
    check(4''d1, "count=1");
    #10;
    check(4''d2, "count=2");
    #10;
    check(4''d3, "count=3");
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    check(4''d14, "count=14 (near max)");
    #10;
    check(4''d15, "count=15 (max)");
    #10;
    check(4''d0, "count=0 (wrap from 15)");
    #10;
    check(4''d1, "count=1 (after wrap)");
    rst = 1; #12;
    check(4''b0000, "rst after counting -> count=0");
    #10;
    check(4''d1, "count=1 (resume after reset)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 6, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (87, 9, 'vectors 1-10 (final-a)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", count, count);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    rst = 1; #12;
    check(4''b0000, "rst -> count=0");
    #10;
    check(4''d1, "count=1");
    #10;
    check(4''d2, "count=2");
    #10;
    check(4''d3, "count=3");
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    check(4''d14, "count=14 (near max)");
    #10;
    check(4''d15, "count=15 (max)");
    #10;
    check(4''d0, "count=0 (wrap from 15)");
    #10;
    check(4''d1, "count=1 (after wrap)");
    rst = 1; #12;
    check(4''b0000, "rst after counting -> count=0");
    #10;
    check(4''d1, "count=1 (resume after reset)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 7, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (88, 9, 'vectors 1-10 (final-b)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", count, count);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    rst = 1; #12;
    check(4''b0000, "rst -> count=0");
    #10;
    check(4''d1, "count=1");
    #10;
    check(4''d2, "count=2");
    #10;
    check(4''d3, "count=3");
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    check(4''d14, "count=14 (near max)");
    #10;
    check(4''d15, "count=15 (max)");
    #10;
    check(4''d0, "count=0 (wrap from 15)");
    #10;
    check(4''d1, "count=1 (after wrap)");
    rst = 1; #12;
    check(4''b0000, "rst after counting -> count=0");
    #10;
    check(4''d1, "count=1 (resume after reset)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 8, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (89, 9, 'vectors 1-10 (final-c)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", count, count);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    rst = 1; #12;
    check(4''b0000, "rst -> count=0");
    #10;
    check(4''d1, "count=1");
    #10;
    check(4''d2, "count=2");
    #10;
    check(4''d3, "count=3");
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    check(4''d14, "count=14 (near max)");
    #10;
    check(4''d15, "count=15 (max)");
    #10;
    check(4''d0, "count=0 (wrap from 15)");
    #10;
    check(4''d1, "count=1 (after wrap)");
    rst = 1; #12;
    check(4''b0000, "rst after counting -> count=0");
    #10;
    check(4''d1, "count=1 (resume after reset)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 9, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (90, 9, 'vectors 1-10 (final-d)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", count, count);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    rst = 1; #12;
    check(4''b0000, "rst -> count=0");
    #10;
    check(4''d1, "count=1");
    #10;
    check(4''d2, "count=2");
    #10;
    check(4''d3, "count=3");
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    #10;
    check(4''d14, "count=14 (near max)");
    #10;
    check(4''d15, "count=15 (max)");
    #10;
    check(4''d0, "count=0 (wrap from 15)");
    #10;
    check(4''d1, "count=1 (after wrap)");
    rst = 1; #12;
    check(4''b0000, "rst after counting -> count=0");
    #10;
    check(4''d1, "count=1 (resume after reset)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 10, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (91, 10, 'vectors 1-3 (basic)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", result, result);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 4''d3; b = 4''d2; op = 2''d0; #1;
    check(4''d5, "ADD 3+2=5");
    a = 4''d7; b = 4''d4; op = 2''d0; #1;
    check(4''d11, "ADD 7+4=11");
    a = 4''d15; b = 4''d1; op = 2''d0; #1;
    check(4''d0, "ADD 15+1=0 (overflow)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 1, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (92, 10, 'vectors 1-3 (verify)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", result, result);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 4''d3; b = 4''d2; op = 2''d0; #1;
    check(4''d5, "ADD 3+2=5");
    a = 4''d7; b = 4''d4; op = 2''d0; #1;
    check(4''d11, "ADD 7+4=11");
    a = 4''d15; b = 4''d1; op = 2''d0; #1;
    check(4''d0, "ADD 15+1=0 (overflow)");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 3);
    $finish;
  end
endmodule', 'PUBLIC', 0.1, 2, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (93, 10, 'vectors 1-10 (full)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", result, result);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 4''d3; b = 4''d2; op = 2''d0; #1;
    check(4''d5, "ADD 3+2=5");
    a = 4''d7; b = 4''d4; op = 2''d0; #1;
    check(4''d11, "ADD 7+4=11");
    a = 4''d15; b = 4''d1; op = 2''d0; #1;
    check(4''d0, "ADD 15+1=0 (overflow)");
    a = 4''d7; b = 4''d3; op = 2''d1; #1;
    check(4''d4, "SUB 7-3=4");
    a = 4''d3; b = 4''d7; op = 2''d1; #1;
    check(4''d12, "SUB 3-7=12 (underflow)");
    a = 4''d15; b = 4''d15; op = 2''d1; #1;
    check(4''d0, "SUB 15-15=0");
    a = 4''d12; b = 4''d10; op = 2''d2; #1;
    check(4''d8, "AND 0xC & 0xA = 0x8");
    a = 4''d5; b = 4''d10; op = 2''d2; #1;
    check(4''d0, "AND 0x5 & 0xA = 0x0");
    a = 4''d12; b = 4''d10; op = 2''d3; #1;
    check(4''d14, "OR 0xC | 0xA = 0xE");
    a = 4''d5; b = 4''d10; op = 2''d3; #1;
    check(4''d15, "OR 0x5 | 0xA = 0xF");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 3, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (94, 10, 'vectors 1-10 (repeat)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", result, result);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 4''d3; b = 4''d2; op = 2''d0; #1;
    check(4''d5, "ADD 3+2=5");
    a = 4''d7; b = 4''d4; op = 2''d0; #1;
    check(4''d11, "ADD 7+4=11");
    a = 4''d15; b = 4''d1; op = 2''d0; #1;
    check(4''d0, "ADD 15+1=0 (overflow)");
    a = 4''d7; b = 4''d3; op = 2''d1; #1;
    check(4''d4, "SUB 7-3=4");
    a = 4''d3; b = 4''d7; op = 2''d1; #1;
    check(4''d12, "SUB 3-7=12 (underflow)");
    a = 4''d15; b = 4''d15; op = 2''d1; #1;
    check(4''d0, "SUB 15-15=0");
    a = 4''d12; b = 4''d10; op = 2''d2; #1;
    check(4''d8, "AND 0xC & 0xA = 0x8");
    a = 4''d5; b = 4''d10; op = 2''d2; #1;
    check(4''d0, "AND 0x5 & 0xA = 0x0");
    a = 4''d12; b = 4''d10; op = 2''d3; #1;
    check(4''d14, "OR 0xC | 0xA = 0xE");
    a = 4''d5; b = 4''d10; op = 2''d3; #1;
    check(4''d15, "OR 0x5 | 0xA = 0xF");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 4, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (95, 10, 'vectors 1-10 (edge)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", result, result);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 4''d3; b = 4''d2; op = 2''d0; #1;
    check(4''d5, "ADD 3+2=5");
    a = 4''d7; b = 4''d4; op = 2''d0; #1;
    check(4''d11, "ADD 7+4=11");
    a = 4''d15; b = 4''d1; op = 2''d0; #1;
    check(4''d0, "ADD 15+1=0 (overflow)");
    a = 4''d7; b = 4''d3; op = 2''d1; #1;
    check(4''d4, "SUB 7-3=4");
    a = 4''d3; b = 4''d7; op = 2''d1; #1;
    check(4''d12, "SUB 3-7=12 (underflow)");
    a = 4''d15; b = 4''d15; op = 2''d1; #1;
    check(4''d0, "SUB 15-15=0");
    a = 4''d12; b = 4''d10; op = 2''d2; #1;
    check(4''d8, "AND 0xC & 0xA = 0x8");
    a = 4''d5; b = 4''d10; op = 2''d2; #1;
    check(4''d0, "AND 0x5 & 0xA = 0x0");
    a = 4''d12; b = 4''d10; op = 2''d3; #1;
    check(4''d14, "OR 0xC | 0xA = 0xE");
    a = 4''d5; b = 4''d10; op = 2''d3; #1;
    check(4''d15, "OR 0x5 | 0xA = 0xF");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 5, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (96, 10, 'vectors 1-10 (stress)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", result, result);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 4''d3; b = 4''d2; op = 2''d0; #1;
    check(4''d5, "ADD 3+2=5");
    a = 4''d7; b = 4''d4; op = 2''d0; #1;
    check(4''d11, "ADD 7+4=11");
    a = 4''d15; b = 4''d1; op = 2''d0; #1;
    check(4''d0, "ADD 15+1=0 (overflow)");
    a = 4''d7; b = 4''d3; op = 2''d1; #1;
    check(4''d4, "SUB 7-3=4");
    a = 4''d3; b = 4''d7; op = 2''d1; #1;
    check(4''d12, "SUB 3-7=12 (underflow)");
    a = 4''d15; b = 4''d15; op = 2''d1; #1;
    check(4''d0, "SUB 15-15=0");
    a = 4''d12; b = 4''d10; op = 2''d2; #1;
    check(4''d8, "AND 0xC & 0xA = 0x8");
    a = 4''d5; b = 4''d10; op = 2''d2; #1;
    check(4''d0, "AND 0x5 & 0xA = 0x0");
    a = 4''d12; b = 4''d10; op = 2''d3; #1;
    check(4''d14, "OR 0xC | 0xA = 0xE");
    a = 4''d5; b = 4''d10; op = 2''d3; #1;
    check(4''d15, "OR 0x5 | 0xA = 0xF");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 6, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (97, 10, 'vectors 1-10 (final-a)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", result, result);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 4''d3; b = 4''d2; op = 2''d0; #1;
    check(4''d5, "ADD 3+2=5");
    a = 4''d7; b = 4''d4; op = 2''d0; #1;
    check(4''d11, "ADD 7+4=11");
    a = 4''d15; b = 4''d1; op = 2''d0; #1;
    check(4''d0, "ADD 15+1=0 (overflow)");
    a = 4''d7; b = 4''d3; op = 2''d1; #1;
    check(4''d4, "SUB 7-3=4");
    a = 4''d3; b = 4''d7; op = 2''d1; #1;
    check(4''d12, "SUB 3-7=12 (underflow)");
    a = 4''d15; b = 4''d15; op = 2''d1; #1;
    check(4''d0, "SUB 15-15=0");
    a = 4''d12; b = 4''d10; op = 2''d2; #1;
    check(4''d8, "AND 0xC & 0xA = 0x8");
    a = 4''d5; b = 4''d10; op = 2''d2; #1;
    check(4''d0, "AND 0x5 & 0xA = 0x0");
    a = 4''d12; b = 4''d10; op = 2''d3; #1;
    check(4''d14, "OR 0xC | 0xA = 0xE");
    a = 4''d5; b = 4''d10; op = 2''d3; #1;
    check(4''d15, "OR 0x5 | 0xA = 0xF");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 7, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (98, 10, 'vectors 1-10 (final-b)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", result, result);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 4''d3; b = 4''d2; op = 2''d0; #1;
    check(4''d5, "ADD 3+2=5");
    a = 4''d7; b = 4''d4; op = 2''d0; #1;
    check(4''d11, "ADD 7+4=11");
    a = 4''d15; b = 4''d1; op = 2''d0; #1;
    check(4''d0, "ADD 15+1=0 (overflow)");
    a = 4''d7; b = 4''d3; op = 2''d1; #1;
    check(4''d4, "SUB 7-3=4");
    a = 4''d3; b = 4''d7; op = 2''d1; #1;
    check(4''d12, "SUB 3-7=12 (underflow)");
    a = 4''d15; b = 4''d15; op = 2''d1; #1;
    check(4''d0, "SUB 15-15=0");
    a = 4''d12; b = 4''d10; op = 2''d2; #1;
    check(4''d8, "AND 0xC & 0xA = 0x8");
    a = 4''d5; b = 4''d10; op = 2''d2; #1;
    check(4''d0, "AND 0x5 & 0xA = 0x0");
    a = 4''d12; b = 4''d10; op = 2''d3; #1;
    check(4''d14, "OR 0xC | 0xA = 0xE");
    a = 4''d5; b = 4''d10; op = 2''d3; #1;
    check(4''d15, "OR 0x5 | 0xA = 0xF");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 8, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (99, 10, 'vectors 1-10 (final-c)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", result, result);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 4''d3; b = 4''d2; op = 2''d0; #1;
    check(4''d5, "ADD 3+2=5");
    a = 4''d7; b = 4''d4; op = 2''d0; #1;
    check(4''d11, "ADD 7+4=11");
    a = 4''d15; b = 4''d1; op = 2''d0; #1;
    check(4''d0, "ADD 15+1=0 (overflow)");
    a = 4''d7; b = 4''d3; op = 2''d1; #1;
    check(4''d4, "SUB 7-3=4");
    a = 4''d3; b = 4''d7; op = 2''d1; #1;
    check(4''d12, "SUB 3-7=12 (underflow)");
    a = 4''d15; b = 4''d15; op = 2''d1; #1;
    check(4''d0, "SUB 15-15=0");
    a = 4''d12; b = 4''d10; op = 2''d2; #1;
    check(4''d8, "AND 0xC & 0xA = 0x8");
    a = 4''d5; b = 4''d10; op = 2''d2; #1;
    check(4''d0, "AND 0x5 & 0xA = 0x0");
    a = 4''d12; b = 4''d10; op = 2''d3; #1;
    check(4''d14, "OR 0xC | 0xA = 0xE");
    a = 4''d5; b = 4''d10; op = 2''d3; #1;
    check(4''d15, "OR 0x5 | 0xA = 0xF");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 9, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.test_cases (id, problem_id, name, description, testbench, visibility, weight, execution_order, enabled)
VALUES (100, 10, 'vectors 1-10 (final-d)', 'Phase 9B comprehensive test', 'module testbench;
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
      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);
      $display("HDLFORGE_RECEIVED:%0d (0b%b)", result, result);
      $display("HDLFORGE_TEST_FAIL");
    end
  endtask
  initial begin
    a = 4''d3; b = 4''d2; op = 2''d0; #1;
    check(4''d5, "ADD 3+2=5");
    a = 4''d7; b = 4''d4; op = 2''d0; #1;
    check(4''d11, "ADD 7+4=11");
    a = 4''d15; b = 4''d1; op = 2''d0; #1;
    check(4''d0, "ADD 15+1=0 (overflow)");
    a = 4''d7; b = 4''d3; op = 2''d1; #1;
    check(4''d4, "SUB 7-3=4");
    a = 4''d3; b = 4''d7; op = 2''d1; #1;
    check(4''d12, "SUB 3-7=12 (underflow)");
    a = 4''d15; b = 4''d15; op = 2''d1; #1;
    check(4''d0, "SUB 15-15=0");
    a = 4''d12; b = 4''d10; op = 2''d2; #1;
    check(4''d8, "AND 0xC & 0xA = 0x8");
    a = 4''d5; b = 4''d10; op = 2''d2; #1;
    check(4''d0, "AND 0x5 & 0xA = 0x0");
    a = 4''d12; b = 4''d10; op = 2''d3; #1;
    check(4''d14, "OR 0xC | 0xA = 0xE");
    a = 4''d5; b = 4''d10; op = 2''d3; #1;
    check(4''d15, "OR 0x5 | 0xA = 0xF");
    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / 10);
    $finish;
  end
endmodule', 'HIDDEN', 0.1, 10, TRUE)
ON CONFLICT (id) DO NOTHING;

SELECT setval(pg_get_serial_sequence('public.test_cases', 'id'), COALESCE(MAX(id), 1)) FROM public.test_cases;

-- 3. CONCEPTS
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (1, 'and-gate', 'AND Gate', '', 'combinational')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (2, 'or-gate', 'OR Gate', '', 'combinational')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (3, 'not-gate', 'NOT Gate', '', 'combinational')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (4, 'nand-nor', 'NAND and NOR Gates', '', 'combinational')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (5, 'xor-xnor', 'XOR and XNOR Gates', '', 'combinational')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (6, 'truth-tables', 'Truth Tables', '', 'combinational')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (7, 'boolean-expressions', 'Boolean Expressions', '', 'combinational')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (8, 'combinational', 'Combinational Logic', '', 'combinational')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (9, 'continuous-assignment', 'Continuous Assignment', '', 'combinational')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (10, 'always-comb', 'always_comb Block', '', 'combinational')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (11, 'mux', 'Multiplexers', '', 'combinational')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (12, 'decoder', 'Decoders', '', 'combinational')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (13, 'encoder', 'Encoders', '', 'combinational')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (14, 'comparator', 'Comparators', '', 'combinational')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (15, 'adder', 'Adders', '', 'arithmetic')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (16, 'sequential', 'Sequential Logic', '', 'sequential')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (17, 'flip-flop', 'Flip-Flops', '', 'sequential')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (18, 'register', 'Registers', '', 'sequential')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (19, 'counter', 'Counters', '', 'sequential')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (20, 'clock', 'Clock Signals', '', 'sequential')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (21, 'reset', 'Reset Logic', '', 'sequential')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (22, 'always-ff', 'always_ff Block', '', 'sequential')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (23, 'binary-arithmetic', 'Binary Arithmetic', '', 'arithmetic')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (24, 'signed-unsigned', 'Signed vs Unsigned', '', 'arithmetic')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (25, 'alu', 'ALU Design', '', 'arithmetic')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (26, 'overflow', 'Arithmetic Overflow', '', 'arithmetic')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (27, 'parameterized', 'Parameterized Design', '', 'rtl-design')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (28, 'fsm', 'Finite State Machines', '', 'fsm')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (29, 'moore-fsm', 'Moore FSM', '', 'fsm')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (30, 'mealy-fsm', 'Mealy FSM', '', 'fsm')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (31, 'state-encoding', 'State Encoding', '', 'fsm')
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.concepts (id, slug, name, description, category)
VALUES (32, 'fsm-patterns', 'FSM Coding Patterns', '', 'fsm')
ON CONFLICT (slug) DO NOTHING;

SELECT setval(pg_get_serial_sequence('public.concepts', 'id'), COALESCE(MAX(id), 1)) FROM public.concepts;

-- 4. PROBLEM CONCEPTS
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (1, 1) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (1, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (1, 9) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (2, 2) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (2, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (2, 9) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (3, 3) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (3, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (3, 9) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (4, 5) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (4, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (4, 9) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (5, 11) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (5, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (5, 9) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (6, 15) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (6, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (6, 23) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (7, 15) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (7, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (7, 23) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (8, 17) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (8, 16) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (8, 22) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (8, 20) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (9, 19) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (9, 16) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (9, 22) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (10, 25) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (10, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.problem_concepts (problem_id, concept_id) VALUES (10, 27) ON CONFLICT DO NOTHING;

-- 5. LEARNING PATHS
INSERT INTO public.learning_paths (id, slug, title, description, difficulty, estimated_hours, published)
VALUES (1, 'rtl-foundations', 'RTL Foundations', 'Master the fundamentals of Register Transfer Level design, from basic digital logic to advanced RTL patterns.', 'EASY', 40, TRUE)
ON CONFLICT (slug) DO NOTHING;
SELECT setval(pg_get_serial_sequence('public.learning_paths', 'id'), COALESCE(MAX(id), 1)) FROM public.learning_paths;

-- 6. LEARNING MODULES
INSERT INTO public.learning_modules (id, learning_path_id, slug, title, description, order_index)
VALUES (1, 1, 'digital-logic-fundamentals', 'Digital Logic Fundamentals', 'Learn the building blocks of all digital circuits: logic gates, truth tables, and Boolean algebra.', 0)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.learning_modules (id, learning_path_id, slug, title, description, order_index)
VALUES (2, 1, 'combinational-logic', 'Combinational Logic', 'Build circuits where outputs depend only on current inputs: multiplexers, decoders, encoders, and adders.', 1)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.learning_modules (id, learning_path_id, slug, title, description, order_index)
VALUES (3, 1, 'sequential-logic', 'Sequential Logic', 'Learn circuits with memory: flip-flops, registers, and counters.', 2)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.learning_modules (id, learning_path_id, slug, title, description, order_index)
VALUES (4, 1, 'arithmetic-rtl', 'Arithmetic RTL', 'Implement arithmetic operations in RTL: addition, subtraction, and ALU design.', 3)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.learning_modules (id, learning_path_id, slug, title, description, order_index)
VALUES (5, 1, 'fsm-fundamentals', 'FSM Fundamentals', 'Master Finite State Machines - the backbone of digital control logic.', 4)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.learning_modules (id, learning_path_id, slug, title, description, order_index)
VALUES (6, 1, 'memories-and-storage', 'Memories and Storage', 'Understand different memory technologies: registers, SRAM, and ROM for storing data in digital systems.', 5)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.learning_modules (id, learning_path_id, slug, title, description, order_index)
VALUES (7, 1, 'rtl-design-patterns', 'RTL Design Patterns', 'Master reusable design patterns: parameterization, shift registers, and pipelining.', 6)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.learning_modules (id, learning_path_id, slug, title, description, order_index)
VALUES (8, 1, 'hdl-verification', 'HDL Verification Fundamentals', 'Learn to verify your designs with testbenches and assertions.', 7)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.learning_modules (id, learning_path_id, slug, title, description, order_index)
VALUES (9, 1, 'advanced-rtl', 'Advanced RTL Concepts', 'Master power reduction, resource sharing, and synthesis-aware design.', 8)
ON CONFLICT (slug) DO NOTHING;
SELECT setval(pg_get_serial_sequence('public.learning_modules', 'id'), COALESCE(MAX(id), 1)) FROM public.learning_modules;

-- 7. LESSONS
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (1, 1, 'what-is-digital-logic', 'What is Digital Logic?', 'Understanding digital signals and logic levels.', '## What is Digital Logic?

Digital logic is the foundation of all modern computing. It deals with signals that have only two possible values: **0** (low/off) and **1** (high/on).

### Why Digital Logic?

- **Reliability**: Digital circuits tolerate noise better than analog circuits
- **Reproducibility**: Same input always produces same output
- **Scalability**: Billions of gates can be integrated on a single chip

### Logic Levels

| Level | Voltage | Binary |
|-------|---------|--------|
| Low | 0V | 0 |
| High | 1.8V-5V | 1 |

### Key Concepts

- **Logic Gate**: A circuit that performs a basic logical operation
- **Boolean Algebra**: Mathematical system for analyzing digital circuits
- **Truth Table**: A table showing all possible input combinations and their outputs

### Example: Simple Digital Signal

```systemverilog
// A digital signal alternates between 0 and 1
module clock_generator (
    output logic clk
);
    initial clk = 0;
    always #5 clk = ~clk;  // Toggle every 5 time units
endmodule
```

In this example, `clk` is a digital signal that alternates between 0 and 1 every 5 time units.', 0, 10, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (2, 1, 'and-or-not-gates', 'AND, OR, NOT Gates', 'Master the three fundamental logic gates.', '## AND, OR, NOT Gates

These three gates form the foundation of all digital logic.

### AND Gate

Output is **1** only when **both** inputs are 1.

| A | B | A AND B |
|---|---|---------|
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

```systemverilog
module and_gate (
    input  logic a,
    input  logic b,
    output logic y
);
    assign y = a & b;
endmodule
```

### OR Gate

Output is **1** when **at least one** input is 1.

| A | B | A OR B |
|---|---|--------|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 1 |

```systemverilog
module or_gate (
    input  logic a,
    input  logic b,
    output logic y
);
    assign y = a | b;
endmodule
```

### NOT Gate (Inverter)

Output is the **opposite** of the input.

| A | NOT A |
|---|-------|
| 0 | 1 |
| 1 | 0 |

```systemverilog
module not_gate (
    input  logic a,
    output logic y
);
    assign y = ~a;
endmodule
```

### Key Takeaways

- `&` is the AND operator
- `|` is the OR operator
- `~` is the NOT operator
- These operators work on individual bits or vectors', 1, 20, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (3, 1, 'nand-nor-xor-xnor', 'NAND, NOR, XOR, XNOR', 'Learn derived logic gates and their applications.', '## NAND, NOR, XOR, XNOR Gates

### NAND Gate (NOT AND)

Output is 0 only when both inputs are 1.

```systemverilog
module nand_gate (
    input  logic a,
    input  logic b,
    output logic y
);
    assign y = ~(a & b);
endmodule
```

### NOR Gate (NOT OR)

Output is 1 only when both inputs are 0.

```systemverilog
module nor_gate (
    input  logic a,
    input  logic b,
    output logic y
);
    assign y = ~(a | b);
endmodule
```

### XOR Gate (Exclusive OR)

Output is 1 when inputs are **different**.

| A | B | A XOR B |
|---|---|---------|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

```systemverilog
module xor_gate (
    input  logic a,
    input  logic b,
    output logic y
);
    assign y = a ^ b;
endmodule
```

### XNOR Gate (Exclusive NOR)

Output is 1 when inputs are **the same**.

```systemverilog
module xnor_gate (
    input  logic a,
    input  logic b,
    output logic y
);
    assign y = ~(a ^ b);
endmodule
```

### Applications

- **NAND/NOR**: Universal gates - any logic function can be built using only NAND or only NOR
- **XOR**: Parity checking, addition (half adder), encryption
- **XNOR**: Equality comparison, coincidence detection', 2, 20, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (4, 1, 'truth-tables-boolean', 'Truth Tables and Boolean Expressions', 'Analyze and simplify logic circuits using truth tables.', '## Truth Tables and Boolean Expressions

### Truth Tables

A truth table shows every possible input combination and the corresponding output.

For a 2-input function: 2^2 = 4 rows
For a 3-input function: 2^3 = 8 rows

### Example: Majority Function

The majority function outputs 1 when more than half the inputs are 1.

| A | B | C | Output |
|---|---|---|--------|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | 0 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 1 |
| 1 | 1 | 1 | 1 |

Boolean expression: `AB + BC + AC`

### Boolean Algebra Laws

| Law | Expression |
|-----|------------|
| Identity | A + 0 = A, A · 1 = A |
| Null | A + 1 = 1, A · 0 = 0 |
| Idempotent | A + A = A, A · A = A |
| Complement | A + ~A = 1, A · ~A = 0 |
| Commutative | A + B = B + A |
| Associative | (A + B) + C = A + (B + C) |
| Distributive | A · (B + C) = A·B + A·C |

### Simplification

Use Boolean algebra or Karnaugh maps to minimize expressions.

```systemverilog
// Before simplification: y = (a & b) | (a & ~b)
// After simplification:  y = a

module simplified (
    input  logic a, b,
    output logic y
);
    assign y = a;  // b is irrelevant
endmodule
```

### Karnaugh Maps

K-maps help visualize and simplify Boolean expressions for up to 6 variables.

Group adjacent 1s in powers of 2 (1, 2, 4, 8...) to find the simplest expression.', 3, 25, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (5, 2, 'continuous-assignment', 'Continuous Assignment with assign', 'Learn the fundamental construct for combinational logic.', '## Continuous Assignment

The `assign` statement creates combinational logic that continuously evaluates.

### Syntax

```systemverilog
module continuous_example (
    input  logic a, b, c,
    output logic y
);
    // Simple assign
    assign y = a & b;

    // Multi-bit assign
    logic [7:0] data_in;
    logic [7:0] data_out;
    assign data_out = data_in + 8''d1;

    // Conditional (ternary) assign
    assign y = a ? b : c;
endmodule
```

### Rules

1. **Left side** must be a net (wire/logic), not a variable
2. **Right side** can be any expression
3. Updates happen **continuously** - whenever inputs change
4. Multiple assigns to the same net create **multiple drivers** (error!)

### When to Use assign

- Simple combinational expressions
- When you want the output to always follow the input
- For conditional logic (ternary operator)

### Example: 2-input MUX

```systemverilog
module mux2 (
    input  logic a, b, sel,
    output logic y
);
    assign y = sel ? b : a;
endmodule
```

This is the simplest form of a multiplexer: when sel=0, output a; when sel=1, output b.', 0, 15, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (6, 2, 'always-comb', 'The always_comb Block', 'Use always_comb for complex combinational logic.', '## always_comb Block

`always_comb` is used for combinational logic that requires procedural (if/else, case) statements.

### Syntax

```systemverilog
module always_comb_example (
    input  logic [1:0] sel,
    input  logic [3:0] a, b, c, d,
    output logic [3:0] y
);
    always_comb begin
        case (sel)
            2''b00: y = a;
            2''b01: y = b;
            2''b10: y = c;
            2''b11: y = d;
            default: y = 4''b0;
        endcase
    end
endmodule
```

### Key Rules

1. **Sensitivity list** is inferred - all inputs on RHS are automatically included
2. **Must assign** to the output in ALL code paths (no latches!)
3. **No timing** control (#delay, @(posedge))
4. **One block** per signal - don''t have multiple always_comb blocks driving the same signal

### Common Mistakes

```systemverilog
// BAD: Incomplete assignment creates a latch
always_comb begin
    if (sel)
        y = a;
    // Missing else - y retains value = LATCH!
end

// GOOD: Complete assignment
always_comb begin
    if (sel)
        y = a;
    else
        y = b;
end
```

### assign vs always_comb

| Feature | assign | always_comb |
|---------|--------|-------------|
| Syntax | Expression only | Procedural (if/else, case) |
| Multiple outputs | Separate statements | Single block |
| Readability | Simple expressions | Complex logic |
| Synthesis | Equivalent | Equivalent |', 1, 20, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (7, 2, 'multiplexers', 'Multiplexers', 'Build data selectors from simple to parameterized.', '## Multiplexers (MUX)

A multiplexer selects one of several inputs based on a selector signal.

### 2:1 MUX

```systemverilog
module mux2to1 (
    input  logic a, b,
    input  logic sel,
    output logic y
);
    assign y = sel ? b : a;
endmodule
```

### 4:1 MUX

```systemverilog
module mux4to1 (
    input  logic [3:0] d,
    input  logic [1:0] sel,
    output logic y
);
    always_comb begin
        case (sel)
            2''b00: y = d[0];
            2''b01: y = d[1];
            2''b10: y = d[2];
            2''b11: y = d[3];
            default: y = 1''b0;
        endcase
    end
endmodule
```

### Parameterized MUX

```systemverilog
module mux_param #(
    parameter WIDTH = 8,
    parameter N = 4
)(
    input  logic [WIDTH-1:0] d [N],
    input  logic [$clog2(N)-1:0] sel,
    output logic [WIDTH-1:0] y
);
    assign y = d[sel];
endmodule
```

### Applications

- **Data selection**: Choose between multiple data sources
- **Function implementation**: Implement any Boolean function
- **Barrel shifter**: Multi-bit MUX for shifting
- **ALU**: Select operation result

### MUX as Logic

Any Boolean function can be implemented as a MUX:
- Connect input variables to selector
- Connect function values to data inputs', 2, 25, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (8, 2, 'decoders-encoders', 'Decoders and Encoders', 'Convert between binary and one-hot representations.', '## Decoders and Encoders

### Decoder

A decoder converts an n-bit input to 2^n output lines (one-hot).

```systemverilog
module decoder2to4 (
    input  logic [1:0] sel,
    output logic [3:0] y
);
    always_comb begin
        y = 4''b0;
        y[sel] = 1''b1;
    end
endmodule
```

### Priority Encoder

A priority encoder outputs the position of the highest-priority active input.

```systemverilog
module priority_encoder (
    input  logic [3:0] a,
    output logic [1:0] y,
    output logic valid
);
    always_comb begin
        valid = 1''b1;
        casez (a)
            4''b1???: y = 2''d3;
            4''b01??: y = 2''d2;
            4''b001?: y = 2''d1;
            4''b0001: y = 2''d0;
            default: begin
                y = 2''d0;
                valid = 1''b0;
            end
        endcase
    end
endmodule
```

### Applications

- **Memory addressing**: Select memory locations
- **LED displays**: Drive 7-segment displays
- **Register files**: Select registers for read/write
- **Interrupt handling**: Identify interrupt source', 3, 20, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (9, 2, 'adders', 'Adders', 'Build arithmetic circuits from half adders to ripple-carry adders.', '## Adders

### Half Adder

Adds two 1-bit numbers, producing sum and carry.

| A | B | Sum | Carry |
|---|---|-----|-------|
| 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 1 |

```systemverilog
module half_adder (
    input  logic a, b,
    output logic sum, carry
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule
```

### Full Adder

Adds two 1-bit numbers plus a carry input.

```systemverilog
module full_adder (
    input  logic a, b, cin,
    output logic sum, cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule
```

### Ripple Carry Adder

Chains full adders for multi-bit addition.

```systemverilog
module ripple_carry_adder #(
    parameter WIDTH = 4
)(
    input  logic [WIDTH-1:0] a, b,
    input  logic cin,
    output logic [WIDTH-1:0] sum,
    output logic cout
);
    logic [WIDTH:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin : fa
            full_adder fa_inst (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[WIDTH];
endmodule
```

### Carry Lookahead Adder

Faster than ripple carry by computing carry signals in parallel. Used in high-performance processors.', 4, 25, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (10, 3, 'combinational-vs-sequential', 'Combinational vs Sequential Logic', 'Understand the fundamental difference between the two types.', '## Combinational vs Sequential Logic

### Combinational Logic

- Output depends **only on current inputs**
- No memory of past inputs
- Examples: AND gate, MUX, adder

### Sequential Logic

- Output depends on current inputs **AND past state**
- Has memory elements (flip-flops, latches)
- Examples: Counter, register, FSM

### Why Sequential Logic?

- **Counting**: Track events over time
- **Storage**: Remember values
- **Sequencing**: Execute operations in order
- **State machines**: Implement control logic

### The Clock

Sequential circuits typically use a clock signal to synchronize state changes.

```
Clock:  _|‾|_|‾|_|‾|_|‾|_
State:  ___|‾‾‾‾‾|___|‾‾‾‾‾
```

### Two Main Types

| Feature | Latch | Flip-Flop |
|---------|-------|-----------|
| Trigger | Level-sensitive | Edge-triggered |
| Timing | Transparent during enable | Updates on clock edge |
| Usage | Less common | Preferred in synchronous design |

### In SystemVerilog

- `always_ff`: For flip-flops (sequential logic)
- `always_comb`: For combinational logic
- `always_latch`: For latches (avoid when possible)', 0, 15, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (11, 3, 'd-flip-flop', 'The D Flip-Flop', 'Master the most important sequential building block.', '## The D Flip-Flop

The D (Data) flip-flop captures the input value on the clock edge.

### Basic D Flip-Flop

```systemverilog
module d_ff (
    input  logic clk,
    input  logic d,
    output logic q
);
    always_ff @(posedge clk) begin
        q <= d;
    end
endmodule
```

### D Flip-Flop with Reset

```systemverilog
module d_ff_reset (
    input  logic clk,
    input  logic rst_n,  // Active-low reset
    input  logic d,
    output logic q
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1''b0;
        else
            q <= d;
    end
endmodule
```

### Key Concepts

- **posedge clk**: Positive (rising) edge of clock
- **negedge rst_n**: Negative (falling) edge of reset
- **<=**: Non-blocking assignment (use in always_ff)
- **Asynchronous reset**: Reset works regardless of clock

### Timing Parameters

- **Setup time (tsu)**: Data must be stable BEFORE clock edge
- **Hold time (th)**: Data must be stable AFTER clock edge
- **Clock-to-Q (tcq)**: Delay from clock edge to output change

### Why D Flip-Flops?

- **Storage**: Stores 1 bit of data
- **Synchronization**: Aligns data to clock domain
- **Pipeline registers**: Separates pipeline stages
- **Edge detection**: Captures events on clock edges', 1, 20, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (12, 3, 'registers', 'Registers', 'Group flip-flops to store multi-bit values.', '## Registers

A register is a group of flip-flops used to store multi-bit data.

### Simple Register

```systemverilog
module register #(
    parameter WIDTH = 8
)(
    input  logic clk,
    input  logic rst_n,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= ''0;
        else
            q <= d;
    end
endmodule
```

### Register with Enable

```systemverilog
module register_enable #(
    parameter WIDTH = 8
)(
    input  logic clk,
    input  logic rst_n,
    input  logic en,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= ''0;
        else if (en)
            q <= d;
    end
endmodule
```

### Register with Load Control

```systemverilog
module register_load #(
    parameter WIDTH = 8
)(
    input  logic clk,
    input  logic rst_n,
    input  logic load,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= ''0;
        else if (load)
            q <= d;
        // else q retains value (register behavior)
    end
endmodule
```

### Applications

- **Data buffers**: Hold data between pipeline stages
- **Status registers**: Store configuration/status bits
- **Address registers**: Hold memory addresses
- **Counters**: Specialized registers that increment/decrement', 2, 20, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (13, 3, 'counters', 'Counters', 'Build circuits that count events.', '## Counters

Counters are sequential circuits that cycle through a sequence of states.

### Binary Counter

```systemverilog
module counter #(
    parameter WIDTH = 4
)(
    input  logic clk,
    input  logic rst_n,
    output logic [WIDTH-1:0] count
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= ''0;
        else
            count <= count + 1''b1;
    end
endmodule
```

### Counter with Enable

```systemverilog
module counter_enable #(
    parameter WIDTH = 4
)(
    input  logic clk,
    input  logic rst_n,
    input  logic en,
    output logic [WIDTH-1:0] count
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= ''0;
        else if (en)
            count <= count + 1''b1;
    end
endmodule
```

### Up/Down Counter

```systemverilog
module updown_counter #(
    parameter WIDTH = 4
)(
    input  logic clk,
    input  logic rst_n,
    input  logic up_down,  // 1=up, 0=down
    output logic [WIDTH-1:0] count
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= ''0;
        else if (up_down)
            count <= count + 1''b1;
        else
            count <= count - 1''b1;
    end
endmodule
```

### Modulo-N Counter

```systemverilog
module mod_counter #(
    parameter N = 10,
    parameter WIDTH = $clog2(N)
)(
    input  logic clk,
    input  logic rst_n,
    output logic [WIDTH-1:0] count,
    output logic tc  // Terminal count
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= ''0;
            tc <= 1''b0;
        end else if (count == N-1) begin
            count <= ''0;
            tc <= 1''b1;
        end else begin
            count <= count + 1''b1;
            tc <= 1''b0;
        end
    end
endmodule
```

### Applications

- **Frequency dividers**: Divide clock frequency
- **Event counters**: Count external events
- **Timers**: Generate time delays
- **Address generators**: Sequence through memory addresses', 3, 25, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (14, 4, 'binary-arithmetic', 'Binary Arithmetic', 'Fundamentals of binary number representation and operations.', '## Binary Arithmetic

### Number Representation

| System | Base | Digits |
|--------|------|--------|
| Binary | 2 | 0, 1 |
| Decimal | 10 | 0-9 |
| Hexadecimal | 16 | 0-9, A-F |

### Unsigned Binary

Value = sum of (bit × 2^position)

Example: 1011 = 1×8 + 0×4 + 1×2 + 1×1 = 11

### Signed Binary (Two''s Complement)

- **MSB** is the sign bit: 0=positive, 1=negative
- To negate: invert all bits and add 1

Example:
- +5 = 0101
- -5 = 1010 + 1 = 1011

### Overflow

When the result exceeds the representable range:
- 4-bit unsigned: 0-15
- 4-bit signed: -8 to +7

```systemverilog
module arithmetic_example (
    input  logic [3:0] a, b,
    output logic [3:0] sum,
    output logic overflow
);
    logic cout;
    assign {cout, sum} = a + b;
    assign overflow = cout;  // Unsigned overflow
endmodule
```

### Common Operations

| Operation | Expression | Notes |
|-----------|------------|-------|
| Add | a + b | Simple addition |
| Subtract | a - b | Or a + (~b + 1) |
| Multiply | a * b | Can be expensive |
| Divide | a / b | Synthesis may warn |
| Modulo | a % b | Use remainder |', 0, 20, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (15, 4, 'alu-design', 'ALU Design', 'Build an Arithmetic Logic Unit that performs multiple operations.', '## ALU Design

An ALU (Arithmetic Logic Unit) performs multiple arithmetic and logical operations.

### ALU Operations

| Op Code | Operation | Description |
|---------|-----------|-------------|
| 0000 | AND | Bitwise AND |
| 0001 | OR | Bitwise OR |
| 0010 | ADD | Addition |
| 0110 | SUB | Subtraction |
| 0111 | SLT | Set less than |
| 1100 | NOR | Bitwise NOR |

### 4-bit ALU

```systemverilog
module alu #(
    parameter WIDTH = 4
)(
    input  logic [WIDTH-1:0] a, b,
    input  logic [3:0] op,
    output logic [WIDTH-1:0] result,
    output logic zero
);
    always_comb begin
        case (op)
            4''b0000: result = a & b;        // AND
            4''b0001: result = a | b;        // OR
            4''b0010: result = a + b;        // ADD
            4''b0110: result = a - b;        // SUB
            4''b0111: result = {3''b0, $signed(a) < $signed(b)};  // SLT
            4''b1100: result = ~(a | b);     // NOR
            default: result = ''0;
        endcase
    end

    assign zero = (result == ''0);
endmodule
```

### Design Considerations

1. **Operation set**: Choose which operations to support
2. **Data width**: 32-bit, 64-bit, or parameterized
3. **Flags**: Zero, carry, overflow, negative
4. **Performance**: Critical path through ALU affects clock speed

### Parameterized ALU

```systemverilog
module alu_param #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] a, b,
    input  logic [2:0] op,
    output logic [WIDTH-1:0] result
);
    always_comb begin
        case (op)
            3''b000: result = a + b;
            3''b001: result = a - b;
            3''b010: result = a & b;
            3''b011: result = a | b;
            3''b100: result = a ^ b;
            3''b101: result = ~a;
            3''b110: result = a << 1;
            3''b111: result = a >> 1;
            default: result = ''0;
        endcase
    end
endmodule
```', 1, 30, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (16, 5, 'what-is-fsm', 'What is an FSM?', 'Introduction to finite state machines and their applications.', '## What is an FSM?

A Finite State Machine (FSM) is a sequential circuit that transitions between a finite number of states based on inputs.

### Components

1. **States**: A finite set of unique conditions
2. **Inputs**: Signals that affect state transitions
3. **Outputs**: Signals produced in each state
4. **Transitions**: Rules for moving between states

### State Diagram

```
    ┌─────────┐
    │  RESET  │
    └────┬────┘
         │ start
         ▼
    ┌─────────┐     done     ┌─────────┐
    │  STATE_A │─────────────│  STATE_B │
    └─────────┘              └─────────┘
         ▲                         │
         │         reset           │
         └─────────────────────────┘
```

### Types of FSMs

| Type | Output Depends On | Example |
|------|-------------------|---------|
| Moore | Current state only | Traffic light controller |
| Mealy | Current state AND inputs | UART receiver |

### FSM Design Steps

1. **Define states**: List all possible states
2. **Draw state diagram**: Show transitions
3. **Assign binary codes**: Encode states
4. **Write HDL**: Implement in SystemVerilog
5. **Verify**: Test all transitions

### Applications

- **Protocol controllers**: SPI, I2C, UART
- **Bus arbiters**: AMBA, Wishbone
- **Game logic**: Simple game states
- **Control units**: CPU control, memory controllers', 0, 20, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (17, 5, 'moore-fsm', 'Moore FSM Implementation', 'Build a complete Moore FSM in SystemVerilog.', '## Moore FSM Implementation

In a Moore FSM, outputs depend only on the current state.

### Traffic Light Controller

```systemverilog
module traffic_light (
    input  logic clk,
    input  logic rst_n,
    output logic [2:0] light  // {red, yellow, green}
);
    typedef enum logic [1:0] {
        RED,
        GREEN,
        YELLOW
    } state_t;

    state_t state, next_state;
    logic [2:0] timer;

    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
            timer <= 3''d5;
        end else begin
            state <= next_state;
            if (timer == 0)
                timer <= 3''d5;
            else
                timer <= timer - 1;
        end
    end

    // Next state logic
    always_comb begin
        case (state)
            RED: begin
                if (timer == 0)
                    next_state = GREEN;
                else
                    next_state = RED;
            end
            GREEN: begin
                if (timer == 0)
                    next_state = YELLOW;
                else
                    next_state = GREEN;
            end
            YELLOW: begin
                if (timer == 0)
                    next_state = RED;
                else
                    next_state = YELLOW;
            end
            default: next_state = RED;
        endcase
    end

    // Output logic (Moore: depends only on state)
    always_comb begin
        case (state)
            RED:    light = 3''b100;
            GREEN:  light = 3''b001;
            YELLOW: light = 3''b010;
            default: light = 3''b000;
        endcase
    end
endmodule
```

### Moore FSM Template

```systemverilog
module moore_fsm (
    input  logic clk,
    input  logic rst_n,
    input  logic start, done,
    output logic ready, valid
);
    // 1. State encoding
    typedef enum logic [1:0] {
        IDLE, COMPUTE, DONE_ST
    } state_t;

    state_t state, next_state;

    // 2. State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // 3. Next state logic
    always_comb begin
        case (state)
            IDLE:    next_state = start ? COMPUTE : IDLE;
            COMPUTE: next_state = done ? DONE_ST : COMPUTE;
            DONE_ST: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // 4. Output logic
    always_comb begin
        ready = (state == IDLE);
        valid = (state == DONE_ST);
    end
endmodule
```', 1, 25, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (18, 5, 'mealy-fsm', 'Mealy FSM Implementation', 'Build a Mealy FSM where outputs depend on inputs too.', '## Mealy FSM Implementation

In a Mealy FSM, outputs depend on both the current state AND current inputs.

### Sequence Detector (101)

```systemverilog
module sequence_detector (
    input  logic clk,
    input  logic rst_n,
    input  logic din,
    output logic dout
);
    typedef enum logic [1:0] {
        S0,  // No match
        S1,  // Seen "1"
        S2   // Seen "10"
    } state_t;

    state_t state, next_state;

    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        case (state)
            S0: next_state = din ? S1 : S0;
            S1: next_state = din ? S1 : S2;
            S2: next_state = din ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (Mealy: depends on state AND input)
    always_comb begin
        dout = (state == S2) && din;  // Output 1 when in S2 and din=1
    end
endmodule
```

### Moore vs Mealy Comparison

| Feature | Moore | Mealy |
|---------|-------|-------|
| Output depends on | State only | State + Inputs |
| Response time | 1 clock cycle | Immediate |
| Glitch sensitivity | Less | More |
| Number of states | Often more | Often fewer |

### When to Use Mealy

- **Fast response needed**: Output changes immediately with input
- **Fewer states**: Can reduce state count
- **Protocol handlers**: Where timing is critical

### When to Use Moore

- **Clean outputs**: No glitches from input changes
- **Simpler timing**: Output changes only on clock edge
- **Default choice**: Generally preferred unless Mealy is necessary', 2, 25, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (19, 6, 'registers-vs-memory', 'Registers vs Memory', 'Learn when to use registers versus memory blocks.', '## Registers vs Memory

### Register File

A register file is a small, fast array of registers with multiple read and write ports.

```systemverilog
module register_file #(
    parameter WIDTH = 32,
    parameter DEPTH = 8
)(
    input  logic clk,
    input  logic we,
    input  logic [$clog2(DEPTH)-1:0] raddr1, raddr2, waddr,
    input  logic [WIDTH-1:0] wdata,
    output logic [WIDTH-1:0] rdata1, rdata2
);
    logic [WIDTH-1:0] regs [DEPTH];

    always_ff @(posedge clk) begin
        if (we)
            regs[waddr] <= wdata;
    end

    assign rdata1 = regs[raddr1];
    assign rdata2 = regs[raddr2];
endmodule
```

### Memory Hierarchy

| Element | Speed | Size | Cost |
|---------|-------|------|------|
| Registers | Fastest | Small (8-64 bits) | High per bit |
| SRAM | Fast | Medium (KB-MB) | Medium per bit |
| DRAM | Slower | Large (GB) | Low per bit |
| Disk/SSD | Slowest | Very Large | Lowest per bit |

### When to Use Registers

- Small data (8-64 bits)
- Need all bits accessible simultaneously (parallel access)
- High-speed operation required
- Control/status storage

### When to Use Memory

- Large data arrays (kilobytes or more)
- Sequential or burst access patterns
- Area constraints
- Lower speed acceptable

### Common Mistakes

- Using memory for small data (wastes area and power)
- Using registers for large arrays (cannot synthesize efficiently)
- Ignoring read/write port limitations of memory', 0, 15, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (20, 6, 'ram', 'RAM', 'Implement synchronous RAM with read and write ports.', '## RAM (Random Access Memory)

### SRAM vs DRAM

| Feature | SRAM | DRAM |
|---------|------|------|
| Storage | Flip-flop pair | Capacitor |
| Refresh | Not needed | Required |
| Speed | Faster | Slower |
| Density | Lower | Higher |
| Use | Cache, registers | Main memory |

### Single-Port RAM

```systemverilog
module ram_sp #(
    parameter WIDTH = 8,
    parameter DEPTH = 256
)(
    input  logic clk,
    input  logic we,
    input  logic [$clog2(DEPTH)-1:0] addr,
    input  logic [WIDTH-1:0] wdata,
    output logic [WIDTH-1:0] rdata
);
    logic [WIDTH-1:0] mem [DEPTH];

    always_ff @(posedge clk) begin
        if (we)
            mem[addr] <= wdata;
        rdata <= mem[addr];
    end
endmodule
```

### Simple Dual-Port RAM

```systemverilog
module ram_sdp #(
    parameter WIDTH = 8,
    parameter DEPTH = 256
)(
    input  logic clk,
    input  logic we,
    input  logic [$clog2(DEPTH)-1:0] waddr, raddr,
    input  logic [WIDTH-1:0] wdata,
    output logic [WIDTH-1:0] rdata
);
    logic [WIDTH-1:0] mem [DEPTH];

    always_ff @(posedge clk) begin
        if (we)
            mem[waddr] <= wdata;
        rdata <= mem[raddr];
    end
endmodule
```

### True Dual-Port RAM

```systemverilog
module ram_tdp #(
    parameter WIDTH = 8,
    parameter DEPTH = 256
)(
    input  logic clk,
    input  logic wea, web,
    input  logic [$clog2(DEPTH)-1:0] addra, addrb,
    input  logic [WIDTH-1:0] dia, dib,
    output logic [WIDTH-1:0] doa, dob
);
    logic [WIDTH-1:0] mem [DEPTH];

    always_ff @(posedge clk) begin
        if (wea) mem[addra] <= dia;
        if (web) mem[addrb] <= dib;
        doa <= mem[addra];
        dob <= mem[addrb];
    end
endmodule
```

### Read-Write Ports

| Type | Read Ports | Write Ports | Use Case |
|------|------------|-------------|----------|
| Single-Port | 1 | 1 | Simple storage |
| Simple Dual-Port | 1 (separate) | 1 (separate) | FIFO, buffers |
| True Dual-Port | 2 | 2 | Dual-clock systems |
| Multi-Port | N | M | Register files |', 1, 20, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (21, 6, 'rom', 'ROM', 'Implement read-only memory for constant data storage.', '## ROM (Read-Only Memory)

### ROM Types

| Type | Programmability | Use Case |
|------|-----------------|----------|
| Mask ROM | Fixed at manufacturing | High-volume products |
| PROM | One-time programmable | Prototyping |
| EPROM | UV-erasable | Development |
| EEPROM | Electrically erasable | Firmware storage |
| Flash | Block-erasable | Storage, boot ROM |

### Simple ROM Implementation

```systemverilog
module rom #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic [$clog2(DEPTH)-1:0] addr,
    output logic [WIDTH-1:0] data
);
    logic [WIDTH-1:0] mem [DEPTH];

    initial begin
        mem[0]  = 8''hA5;
        mem[1]  = 8''h3C;
        mem[2]  = 8''hFF;
        mem[3]  = 8''h00;
        // Initialize other locations
    end

    assign data = mem[addr];
endmodule
```

### ROM with Initialization File

```systemverilog
module rom_file #(
    parameter WIDTH = 8,
    parameter DEPTH = 256
)(
    input  logic [$clog2(DEPTH)-1:0] addr,
    output logic [WIDTH-1:0] data
);
    logic [WIDTH-1:0] mem [DEPTH];

    initial $readmemh("rom_data.hex", mem);

    assign data = mem[addr];
endmodule
```

### Lookup Table (LUT) ROM

```systemverilog
module sin_rom (
    input  logic [7:0] angle,
    output logic [15:0] sin_val
);
    logic [15:0] lut [256];

    initial begin
        lut[0]   = 16''h0000;  // sin(0) = 0
        lut[64]  = 16''h4000;  // sin(90°) = 1.0
        lut[128] = 16''h0000;  // sin(180°) = 0
        lut[192] = 16''hC000;  // sin(270°) = -1.0
        // Fill full table
    end

    assign sin_val = lut[angle];
endmodule
```

### Key Concepts

- **Combinational ROM**: Output is function of address (no clock)
- **Synchronous ROM**: Output registered for better timing
- **Initialization**: Use `initial` block or `$readmemh`
- **Synthesis**: ROM infers block RAM or LUTs depending on size

### Common Mistakes

- Forgetting to initialize ROM contents (undefined behavior)
- Using too large a ROM (consumes too many LUTs)
- Not considering timing for combinational ROM in pipelines', 2, 15, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (22, 7, 'parameterization', 'Parameterization', 'Create flexible, reusable modules with parameters.', '## Parameterization

### Parameter vs Localparam

| Feature | parameter | localparam |
|---------|-----------|------------|
| Override | Can be overridden at instantiation | Cannot be overridden |
| Scope | Module port-like | Internal constant |
| Use | Configurable values | Derived constants |

### Module Parameters

```systemverilog
module adder #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] a, b,
    output logic [WIDTH:0] sum
);
    assign sum = a + b;
endmodule
```

### Parameter Override

```systemverilog
module top;
    logic [7:0]  sum8;
    logic [15:0] sum16;

    adder #(.WIDTH(8))  u_adder8  (.a(8''d5), .b(8''d3), .sum(sum8));
    adder #(.WIDTH(16)) u_adder16 (.a(16''d100), .b(16''d200), .sum(sum16));
endmodule
```

### $clog2 for Address Width

```systemverilog
module param_mux #(
    parameter N = 4
)(
    input  logic [$clog2(N)-1:0] sel,
    input  logic [N-1:0] din,
    output logic y
);
    assign y = din[sel];
endmodule
```

### Derived Parameters

```systemverilog
module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic clk,
    input  logic rst_n,
    input  logic wr_en,
    input  logic [DATA_WIDTH-1:0] wdata,
    output logic [DATA_WIDTH-1:0] rdata,
    output logic full,
    output logic empty
);
    localparam ADDR_WIDTH = $clog2(DEPTH);

    logic [DATA_WIDTH-1:0] mem [DEPTH];
    logic [ADDR_WIDTH:0] wptr, rptr;

    // FIFO logic using derived parameters
endmodule
```

### Best Practices

- Use `parameter` for configurable values
- Use `localparam` for derived constants
- Always provide default values
- Document parameter meanings in comments', 0, 15, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (23, 7, 'shift-registers', 'Shift Registers', 'Build serial-in serial-out, parallel-in serial-out, and barrel shifters.', '## Shift Registers

### Serial-In Serial-Out (SISO)

```systemverilog
module siso #(
    parameter WIDTH = 8
)(
    input  logic clk,
    input  logic rst_n,
    input  logic sin,
    output logic sout
);
    logic [WIDTH-1:0] shift_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_reg <= ''0;
        else
            shift_reg <= {shift_reg[WIDTH-2:0], sin};
    end

    assign sout = shift_reg[WIDTH-1];
endmodule
```

### Parallel-In Serial-Out (PISO)

```systemverilog
module piso #(
    parameter WIDTH = 8
)(
    input  logic clk,
    input  logic rst_n,
    input  logic load,
    input  logic [WIDTH-1:0] parallel_in,
    output logic serial_out
);
    logic [WIDTH-1:0] shift_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_reg <= ''0;
        else if (load)
            shift_reg <= parallel_in;
        else
            shift_reg <= {shift_reg[WIDTH-2:0], 1''b0};
    end

    assign serial_out = shift_reg[WIDTH-1];
endmodule
```

### Barrel Shifter

```systemverilog
module barrel_shifter #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] din,
    input  logic [$clog2(WIDTH)-1:0] shift,
    input  logic direction,  // 0=left, 1=right
    output logic [WIDTH-1:0] dout
);
    logic [WIDTH-1:0] temp;

    always_comb begin
        if (direction)
            temp = din >> shift;
        else
            temp = din << shift;
    end

    assign dout = temp;
endmodule
```

### Applications

| Type | Application |
|------|-------------|
| SISO | Data transmission, delay lines |
| SIPO | Serial-to-parallel conversion |
| PISO | Parallel-to-serial conversion |
| Barrel Shifter | Multiplication/division by powers of 2 |

### Common Mistakes

- Forgetting reset value for shift register
- Off-by-one in shift amount calculation
- Not considering signed vs unsigned shift for arithmetic', 1, 20, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (24, 7, 'pipelines', 'Pipelines', 'Improve throughput by inserting pipeline registers between stages.', '## Pipelines

### Concept

A pipeline divides a combinational path into stages separated by registers, improving clock frequency at the cost of latency.

### Without Pipeline

```
Input → [Combinational Logic] → Output
         (long delay = slow clock)
```

### With Pipeline

```
Input → [Stage 1] → Reg → [Stage 2] → Reg → [Stage 3] → Output
        (shorter delay = faster clock)
```

### Simple Pipeline Example

```systemverilog
module pipeline_3stage #(
    parameter WIDTH = 8
)(
    input  logic clk,
    input  logic rst_n,
    input  logic [WIDTH-1:0] a, b, c,
    output logic [WIDTH-1:0] result
);
    logic [WIDTH-1:0] stage1, stage2;

    // Stage 1: a + b
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage1 <= ''0;
        else
            stage1 <= a + b;
    end

    // Stage 2: stage1 * c
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage2 <= ''0;
        else
            stage2 <= stage1 * c;
    end

    // Stage 3: stage2 - 1
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            result <= ''0;
        else
            result <= stage2 - 1;
    end
endmodule
```

### Pipeline Register

```systemverilog
module pipe_reg #(
    parameter WIDTH = 8
)(
    input  logic clk,
    input  logic rst_n,
    input  logic valid_in,
    input  logic [WIDTH-1:0] data_in,
    output logic valid_out,
    output logic [WIDTH-1:0] data_out
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1''b0;
            data_out  <= ''0;
        end else begin
            valid_out <= valid_in;
            data_out  <= data_in;
        end
    end
endmodule
```

### Throughput vs Latency

| Metric | Without Pipeline | With Pipeline |
|--------|------------------|---------------|
| Latency | 1 cycle | N cycles |
| Throughput | 1 result/cycle | 1 result/cycle (after fill) |
| Clock Period | Long | Short (1/N) |

### Pipeline Hazards

| Hazard | Description | Solution |
|--------|-------------|----------|
| Data | Later stage needs data from earlier | Forwarding, stall |
| Control | Branch changes flow | Branch prediction, stall |
| Structural | Resource conflict | Duplicate resources |

### Common Mistakes

- Not registering all pipeline stages equally
- Forgetting to pipeline valid/strobe signals
- Not handling pipeline flush on exceptions', 2, 25, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (25, 8, 'testbenches', 'Testbenches', 'Build effective testbenches for RTL verification.', '## Testbenches

### Basic Testbench Structure

```systemverilog
module tb_adder;
    logic [7:0] a, b;
    logic [8:0] sum;

    // Instantiate DUT
    adder #(.WIDTH(8)) dut (
        .a(a),
        .b(b),
        .sum(sum)
    );

    // Stimulus
    initial begin
        a = 0; b = 0;
        #10;
        a = 8''d10; b = 8''d20;
        #10;
        a = 8''hFF; b = 8''d1;
        #10;
        $finish;
    end
endmodule
```

### Self-Checking Testbench

```systemverilog
module tb_adder_check;
    logic [7:0] a, b;
    logic [8:0] sum;
    int errors = 0;

    adder #(.WIDTH(8)) dut (.a(a), .b(b), .sum(sum));

    task automatic check(input logic [7:0] ta, tb, input logic [8:0] expected);
        a = ta; b = tb;
        #1;
        if (sum !== expected) begin
            $error("FAIL: %0d + %0d = %0d, expected %0d", ta, tb, sum, expected);
            errors++;
        end
    endtask

    initial begin
        check(0, 0, 0);
        check(10, 20, 30);
        check(255, 1, 256);
        check(128, 128, 256);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("FAILURES: %0d", errors);
        $finish;
    end
endmodule
```

### Stimulus Generation

| Method | Description | Use Case |
|--------|-------------|----------|
| Direct assignment | Hardcoded values | Simple tests |
| Loops | Generate patterns | Exhaustive testing |
| Random | $urandom_range | Constrained random |
| File I/O | $readmemh | Real-world data |

### Common Testbench Patterns

```systemverilog
// Clock generation
logic clk = 0;
always #5 clk = ~clk;

// Reset sequence
logic rst_n = 0;
initial begin
    repeat(3) @(posedge clk);
    rst_n = 1;
end

// Timeout
initial begin
    #10000;
    $error("TIMEOUT");
    $finish;
end
```', 0, 20, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (26, 8, 'assertions', 'Assertions', 'Use SystemVerilog Assertions (SVA) for property checking.', '## Assertions

### Immediate Assertions

```systemverilog
module check_adder (
    input  logic [7:0] a, b,
    input  logic [8:0] sum
);
    // Check no overflow for small values
    property no_overflow_small;
        @(posedge clk) (a < 128 && b < 128) |-> (sum < 256);
    endproperty

    assert property (no_overflow_small)
        else $error("Overflow detected with small operands");
endmodule
```

### Concurrent Assertions

```systemverilog
module protocol_checker (
    input  logic clk,
    input  logic req,
    input  logic ack
);
    // Request must be acknowledged within 4 cycles
    property req_ack;
        @(posedge clk) $rose(req) |-> ##[1:4] $rose(ack);
    endproperty

    assert property (req_ack)
        else $error("ACK not received within 4 cycles");

    // ACK cannot be asserted without prior REQ
    property no_spurious_ack;
        @(posedge clk) $rose(ack) |-> $past(req, 1) || $past(req, 2) ||
                                     $past(req, 3) || $past(req, 4);
    endproperty

    assert property (no_spurious_ack)
        else $error("Spurious ACK detected");
endmodule
```

### SVA Basics

| Construct | Meaning |
|-----------|---------|
| `assert` | Check property, report on failure |
| `assume` | Constrain inputs for formal verification |
| `cover` | Measure if property is reachable |
| `property` | Named temporal expression |
| `sequence` | Ordered list of events |

### Simple Sequence Examples

```systemverilog
// Two consecutive rising edges
sequence two_clks;
    @(posedge clk) 1 ##1 1;
endsequence

// Handshake: req followed by ack within 3 cycles
sequence handshake;
    $rose(req) ##[1:3] $rose(ack);
endsequence

// Assert handshake property
property handshake_prop;
    @(posedge clk) handshake;
endproperty

assert property (handshake_prop);
```

### Common Mistakes

- Using immediate assertions where concurrent are needed
- Not disabling assertions during reset
- Over-constraining with assume statements
- Forgetting `else` clause for error reporting', 1, 20, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (27, 9, 'clock-enable', 'Clock Enable and Gating', 'Reduce power with clock enable signals and clock gating.', '## Clock Enable and Gating

### Clock Enable

A clock enable signal controls when flip-flops capture new data, without changing the clock frequency.

```systemverilog
module counter_ce #(
    parameter WIDTH = 8
)(
    input  logic clk,
    input  logic rst_n,
    input  logic ce,
    output logic [WIDTH-1:0] count
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= ''0;
        else if (ce)
            count <= count + 1''b1;
    end
endmodule
```

### Clock Gating

Clock gating removes the clock from inactive modules to save power.

```systemverilog
module clock_gating (
    input  logic clk,
    input  logic en,
    output logic gated_clk
);
    // ICG cell pattern
    logic latch_en;

    always_latch begin
        if (!clk)
            latch_en = en;
    end

    assign gated_clk = clk & latch_en;
endmodule
```

### Enable vs Gating

| Feature | Clock Enable | Clock Gating |
|---------|--------------|--------------|
| Power savings | Moderate | High |
| Timing complexity | Low | Higher |
| Skew concerns | None | Yes (clock tree) |
| Synthesis | Automatic | Explicit or inferred |

### Power Reduction Techniques

| Technique | Description | Power Saving |
|-----------|-------------|--------------|
| Clock gating | Disable clock to idle modules | 30-60% |
| Clock enable | Disable FF updates | 10-30% |
| Operand isolation | Gate inputs to idle logic | 5-20% |
| Power gating | Shut down entire blocks | 50-90% |

### Common Mistakes

- Using clock gating without proper latch (glitches)
- Gating clock for high-frequency designs without careful analysis
- Not accounting for clock tree insertion delay
- Mixing enable and gating inconsistently', 0, 20, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (28, 9, 'resource-sharing', 'Resource Sharing', 'Optimize area by sharing operators and resources.', '## Resource Sharing

### Operator Sharing

When multiple operations occur in mutually exclusive conditions, they can share hardware.

```systemverilog
// WITHOUT sharing: two multipliers
module no_sharing (
    input  logic sel,
    input  logic [7:0] a, b, c, d,
    output logic [15:0] result
);
    always_comb begin
        if (sel)
            result = a * b;  // Multiplier 1
        else
            result = c * d;  // Multiplier 2
    end
endmodule

// WITH sharing: one multiplier
module with_sharing (
    input  logic sel,
    input  logic [7:0] a, b, c, d,
    output logic [15:0] result
);
    logic [7:0] op1, op2;

    always_comb begin
        if (sel) begin
            op1 = a;
            op2 = b;
        end else begin
            op1 = c;
            op2 = d;
        end
    end

    assign result = op1 * op2;  // Single multiplier
endmodule
```

### MUX-Based Sharing

```systemverilog
module mux_sharing (
    input  logic [1:0] sel,
    input  logic [7:0] a, b, c, d,
    output logic [7:0] result
);
    logic [7:0] mux_out;

    always_comb begin
        case (sel)
            2''b00: mux_out = a;
            2''b01: mux_out = b;
            2''b10: mux_out = c;
            default: mux_out = d;
        endcase
    end

    // Single adder shared by all operations
    assign result = mux_out + 8''d1;
endmodule
```

### Time-Multiplexing

```systemverilog
module time_mux #(
    parameter WIDTH = 8
)(
    input  logic clk,
    input  logic rst_n,
    input  logic [WIDTH-1:0] a, b,
    output logic [WIDTH:0] result
);
    logic [WIDTH:0] sum_reg;
    logic sel;

    // Alternate between operations each cycle
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sel <= 1''b0;
        else
            sel <= ~sel;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum_reg <= ''0;
        else if (sel)
            sum_reg <= a + b;
        else
            sum_reg <= sum_reg;  // Hold
    end

    assign result = sum_reg;
endmodule
```

### Sharing Guidelines

| Scenario | Recommendation |
|----------|----------------|
| Mutually exclusive operations | Share operator with MUX inputs |
| Sequential operations | Time-multiply if timing allows |
| Same operation, different data | Single operator, MUX data |
| High-performance required | Duplicate operators (no sharing) |', 1, 15, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO public.lessons (id, module_id, slug, title, description, content, order_index, estimated_minutes, difficulty, published)
VALUES (29, 9, 'synthesizable', 'Synthesizable vs Non-Synthesizable', 'Understand what SystemVerilog constructs can and cannot be synthesized.', '## Synthesizable vs Non-Synthesizable

### Synthesizable Constructs

| Construct | Description |
|-----------|-------------|
| `assign` | Continuous assignment |
| `always_ff` | Sequential logic |
| `always_comb` | Combinational logic |
| `always_latch` | Latch inference |
| `module` | Design unit |
| `parameter` | Compile-time constants |
| `typedef enum` | State encoding |
| `generate` | Conditional instantiation |

### Non-Synthesizable Constructs

| Construct | Description | Purpose |
|-----------|-------------|---------|
| `initial` | Initial block | Testbench only |
| `#delay` | Timing delays | Simulation only |
| `$display` | Display system task | Debugging |
| `$readmemh` | File reading | Initialization |
| `fork/join` | Parallel processes | Testbench |
| `wait` | Wait statement | Simulation |
| `event` | Event triggering | Testbench |

### Synthesis Guidelines

```systemverilog
// GOOD: Synthesizable
module good_example (
    input  logic clk,
    input  logic rst_n,
    input  logic [3:0] sel,
    output logic [7:0] out
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            out <= ''0;
        else
            case (sel)
                4''d0: out <= 8''hAA;
                4''d1: out <= 8''hBB;
                default: out <= ''0;
            endcase
    end
endmodule

// BAD: Non-synthesizable patterns
module bad_example (
    input  logic clk,
    output logic [7:0] out
);
    // initial block - not synthesizable
    initial out = 0;

    // #delay - not synthesizable
    always_ff @(posedge clk)
        #5 out <= out + 1;  // ERROR

    // $display - not synthesizable (but synthesis tools ignore)
    always_ff @(posedge clk)
        $display("Value: %h", out);  // Synthesis ignores
endmodule
```

### Common Mistakes

- Using `initial` blocks in RTL (except for ROM initialization)
- Adding `#delay` in synthesizable code
- Relying on simulation-specific behavior
- Using `$display` for synthesis output (ignored)

### Best Practices

1. Use `always_ff` for sequential, `always_comb` for combinational
2. Avoid `initial` in RTL (except ROM init)
3. Never use `#delay` in synthesizable code
4. Keep simulation-only code in testbenches only
5. Use parameters for compile-time constants', 2, 15, 'EASY', TRUE)
ON CONFLICT (slug) DO NOTHING;
SELECT setval(pg_get_serial_sequence('public.lessons', 'id'), COALESCE(MAX(id), 1)) FROM public.lessons;

-- 8. LESSON PREREQUISITES
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (2, 1) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (3, 2) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (4, 3) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (5, 4) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (6, 5) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (7, 6) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (8, 7) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (9, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (10, 9) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (11, 10) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (12, 11) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (13, 12) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (14, 13) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (15, 14) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (16, 15) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (17, 16) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (18, 17) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (19, 18) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (20, 19) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (21, 20) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (22, 21) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (23, 22) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (24, 23) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (25, 24) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (26, 25) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (27, 26) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (28, 27) ON CONFLICT DO NOTHING;
INSERT INTO public.lesson_prerequisites (lesson_id, prerequisite_lesson_id) VALUES (29, 28) ON CONFLICT DO NOTHING;

-- 9. QUIZZES
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (1, 1, 'Quiz: What is Digital Logic?') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (2, 2, 'Quiz: AND, OR, NOT Gates') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (3, 3, 'Quiz: NAND, NOR, XOR, XNOR') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (4, 4, 'Quiz: Truth Tables and Boolean Expressions') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (5, 5, 'Quiz: Continuous Assignment with assign') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (6, 6, 'Quiz: The always_comb Block') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (7, 7, 'Quiz: Multiplexers') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (8, 8, 'Quiz: Decoders and Encoders') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (9, 9, 'Quiz: Adders') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (10, 10, 'Quiz: Combinational vs Sequential Logic') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (11, 11, 'Quiz: The D Flip-Flop') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (12, 12, 'Quiz: Registers') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (13, 13, 'Quiz: Counters') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (14, 14, 'Quiz: Binary Arithmetic') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (15, 15, 'Quiz: ALU Design') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (16, 16, 'Quiz: What is an FSM?') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (17, 17, 'Quiz: Moore FSM Implementation') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (18, 18, 'Quiz: Mealy FSM Implementation') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (19, 19, 'Quiz: Registers vs Memory') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (20, 20, 'Quiz: RAM') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (21, 21, 'Quiz: ROM') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (22, 22, 'Quiz: Parameterization') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (23, 23, 'Quiz: Shift Registers') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (24, 24, 'Quiz: Pipelines') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (25, 25, 'Quiz: Testbenches') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (26, 26, 'Quiz: Assertions') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (27, 27, 'Quiz: Clock Enable and Gating') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (28, 28, 'Quiz: Resource Sharing') ON CONFLICT DO NOTHING;
INSERT INTO public.quizzes (id, lesson_id, title) VALUES (29, 29, 'Quiz: Synthesizable vs Non-Synthesizable') ON CONFLICT DO NOTHING;
SELECT setval(pg_get_serial_sequence('public.quizzes', 'id'), COALESCE(MAX(id), 1)) FROM public.quizzes;

-- 10. QUIZ QUESTIONS
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (1, 1, 'How many possible values does a digital signal have?', 'multiple_choice', '["1", "2", "4", "8"]', '2', 'Digital signals have exactly two possible values: 0 (low) and 1 (high).', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (2, 1, 'What does a truth table show?', 'multiple_choice', '["Voltage levels", "All input/output combinations", "Power consumption", "Signal timing"]', 'All input/output combinations', 'A truth table lists every possible combination of inputs and their corresponding outputs.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (3, 2, 'What is the output of an AND gate when A=1 and B=0?', 'multiple_choice', '["0", "1", "Unknown", "Error"]', '0', 'AND gate outputs 1 only when BOTH inputs are 1. Since B=0, output is 0.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (4, 2, 'Which operator is used for NOT in SystemVerilog?', 'multiple_choice', '["!", "~", "&", "|"]', '~', 'The tilde (~) is the bitwise NOT operator in SystemVerilog.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (5, 2, 'What is the output of an OR gate when A=0 and B=1?', 'multiple_choice', '["0", "1", "Unknown", "Error"]', '1', 'OR gate outputs 1 when at least one input is 1. Since B=1, output is 1.', 2)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (6, 3, 'When does an XOR gate output 1?', 'multiple_choice', '["Both inputs are 1", "Both inputs are 0", "Inputs are different", "Inputs are the same"]', 'Inputs are different', 'XOR outputs 1 when the two inputs have different values.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (7, 3, 'Which gate is considered a universal gate?', 'multiple_choice', '["AND", "OR", "XOR", "NAND"]', 'NAND', 'NAND is a universal gate because any logic function can be implemented using only NAND gates.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (8, 4, 'How many rows does a truth table have for 3 inputs?', 'multiple_choice', '["3", "6", "8", "9"]', '8', 'For n inputs, a truth table has 2^n rows. For 3 inputs: 2^3 = 8 rows.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (9, 4, 'What is A + ~A equal to?', 'multiple_choice', '["0", "1", "A", "~A"]', '1', 'By the Complement law, a variable OR its complement always equals 1.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (10, 5, 'What happens when inputs change in a continuous assignment?', 'multiple_choice', '["Nothing", "Output updates immediately", "Output updates on clock edge", "Output updates after delay"]', 'Output updates immediately', 'Continuous assignments evaluate and update outputs whenever inputs change.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (11, 5, 'Can you assign to a reg variable using assign?', 'multiple_choice', '["Yes", "No", "Only in always blocks", "Only with #delay"]', 'No', 'assign statements drive nets (wire/logic), not reg variables. Use always blocks for reg variables.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (12, 6, 'What happens if you don''t assign a value in all code paths of always_comb?', 'multiple_choice', '["Compilation error", "Inferred latch", "Output is 0", "Nothing"]', 'Inferred latch', 'Incomplete assignments in always_comb create latches, which are generally undesirable in combinational logic.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (13, 6, 'Can always_comb contain #delay statements?', 'multiple_choice', '["Yes", "No", "Only at the end", "Only with special syntax"]', 'No', 'always_comb represents purely combinational logic and cannot contain timing controls.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (14, 7, 'How many selector bits are needed for a 4:1 MUX?', 'multiple_choice', '["1", "2", "3", "4"]', '2', 'A 4:1 MUX has 4 data inputs, requiring log2(4) = 2 selector bits.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (15, 7, 'What is a common use of a parameterized MUX?', 'multiple_choice', '["Only 2:1 selection", "Variable-width data paths", "Clock generation", "Reset logic"]', 'Variable-width data paths', 'Parameterized MUXes can handle different data widths by setting the WIDTH parameter.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (16, 8, 'How many output lines does a 3-to-8 decoder have?', 'multiple_choice', '["3", "6", "8", "16"]', '8', 'A decoder with n inputs has 2^n outputs. For 3 inputs: 2^3 = 8 outputs.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (17, 9, 'What is the sum output of a half adder when A=1 and B=1?', 'multiple_choice', '["0", "1", "2", "Error"]', '0', '1 + 1 = 10 in binary. Sum is 0, carry is 1.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (18, 9, 'What is the main disadvantage of a ripple carry adder?', 'multiple_choice', '["Uses too many gates", "Slow carry propagation", "Cannot handle signed numbers", "Requires clock"]', 'Slow carry propagation', 'In a ripple carry adder, the carry must propagate through each full adder, causing delay.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (19, 10, 'What makes sequential logic different from combinational logic?', 'multiple_choice', '["Faster", "Has memory", "Uses fewer gates", "No clock needed"]', 'Has memory', 'Sequential logic has memory elements that store past state, allowing outputs to depend on both current and past inputs.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (20, 10, 'Which is preferred for synchronous design?', 'multiple_choice', '["Latches", "Flip-flops", "Both equally", "Neither"]', 'Flip-flops', 'Edge-triggered flip-flops are preferred because they provide predictable timing and are easier to analyze.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (21, 11, 'On which clock edge does a standard D flip-flop capture data?', 'multiple_choice', '["Negative edge", "Positive edge", "Both edges", "Level"]', 'Positive edge', 'A standard D flip-flop captures data on the rising (positive) edge of the clock.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (22, 11, 'What is the purpose of the reset signal?', 'multiple_choice', '["Speed up circuit", "Set initial state", "Generate clock", "Reduce power"]', 'Set initial state', 'Reset initializes the flip-flop to a known state (usually 0) when the system starts or needs initialization.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (23, 12, 'What is a register made of?', 'multiple_choice', '["Logic gates only", "Flip-flops", "Memory cells", "Multiplexers"]', 'Flip-flops', 'A register is a group of flip-flops, each storing one bit of data.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (24, 12, 'What does the enable signal do in a register?', 'multiple_choice', '["Resets the register", "Enables data storage", "Generates clock", "Powers down the register"]', 'Enables data storage', 'The enable signal controls when new data is loaded into the register. When disabled, the register retains its current value.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (25, 13, 'What does a modulo-N counter do when it reaches N-1?', 'multiple_choice', '["Stops counting", "Overflows to 0", "Goes to N", "Resets asynchronously"]', 'Overflows to 0', 'A modulo-N counter counts from 0 to N-1, then wraps around to 0.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (26, 13, 'How many flip-flops are needed for a 4-bit counter?', 'multiple_choice', '["2", "3", "4", "8"]', '4', 'A 4-bit counter needs 4 flip-flops, one for each bit of the count value.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (27, 14, 'What is the two''s complement of 0101 (5)?', 'multiple_choice', '["1010", "1011", "1101", "1110"]', '1011', 'To find two''s complement: invert bits (1010) then add 1 (1011). This represents -5.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (28, 14, 'What is the range of a 4-bit signed number?', 'multiple_choice', '["0 to 15", "-8 to 7", "-16 to 15", "-7 to 7"]', '-8 to 7', 'A 4-bit signed number uses one bit for sign, giving range -(2^3) to (2^3)-1 = -8 to 7.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (29, 15, 'What does the zero flag indicate in an ALU?', 'multiple_choice', '["No input", "Result is zero", "No operation", "Overflow occurred"]', 'Result is zero', 'The zero flag is set when the ALU result equals zero, useful for comparison operations.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (30, 15, 'Which operation does SLT perform?', 'multiple_choice', '["Shift left", "Set less than", "Subtract lower", "Select lowest"]', 'Set less than', 'SLT (Set Less Than) outputs 1 if the first operand is less than the second (signed comparison).', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (31, 16, 'What are the three main components of an FSM?', 'multiple_choice', '["Clock, reset, enable", "States, inputs, outputs", "Registers, MUX, ALU", "Input, process, output"]', 'States, inputs, outputs', 'An FSM consists of states, inputs that trigger transitions, and outputs produced in each state.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (32, 16, 'In a Moore FSM, outputs depend on:', 'multiple_choice', '["Inputs only", "Current state only", "Both state and inputs", "Clock edge"]', 'Current state only', 'In a Moore FSM, outputs are determined solely by the current state, making timing more predictable.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (33, 17, 'In the traffic light example, what triggers state transitions?', 'multiple_choice', '["Button press", "Timer reaching zero", "Random events", "External sensors"]', 'Timer reaching zero', 'The traffic light transitions when its timer counts down to zero, spending a fixed time in each state.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (34, 17, 'What is the purpose of the next_state logic?', 'multiple_choice', '["Generates outputs", "Determines state transitions", "Resets the FSM", "Controls timing"]', 'Determines state transitions', 'The next_state logic computes what the next state should be based on current state and inputs.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (35, 18, 'What is the main difference between Moore and Mealy FSMs?', 'multiple_choice', '["Number of states", "Output depends on inputs", "Clock usage", "Reset type"]', 'Output depends on inputs', 'In Mealy FSMs, outputs are a function of both the current state and current inputs, unlike Moore where outputs depend only on state.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (36, 18, 'Why might a Mealy FSM have fewer states than a Moore FSM?', 'multiple_choice', '["Uses more flip-flops", "Outputs can respond immediately to inputs", "Has simpler logic", "Doesn''t need a clock"]', 'Outputs can respond immediately to inputs', 'Mealy outputs can change with inputs within a state, potentially eliminating the need for extra states to handle output timing.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (37, 19, 'Which is faster: a register file or SRAM?', 'multiple_choice', '["SRAM", "Register file", "Same speed", "Depends on size"]', 'Register file', 'Register files are built from flip-flops and provide the fastest access, but occupy more area per bit than SRAM.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (38, 19, 'For a 128-bit data path, which storage is most appropriate?', 'multiple_choice', '["DRAM", "Register file", "SSD", "Hard drive"]', 'Register file', '128 bits is small enough for a register file, which provides the speed and parallel access needed for data paths.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (39, 20, 'What is the key difference between SRAM and DRAM?', 'multiple_choice', '["SRAM needs refresh, DRAM does not", "DRAM needs refresh, SRAM does not", "SRAM is slower", "DRAM uses flip-flops"]', 'DRAM needs refresh, SRAM does not', 'DRAM stores data in capacitors that leak charge and must be periodically refreshed. SRAM uses flip-flop pairs that maintain state without refresh.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (40, 20, 'In a single-port RAM, can you read and write simultaneously?', 'multiple_choice', '["Yes, always", "No, only one operation per cycle", "Only on different addresses", "Only if clock is fast enough"]', 'No, only one operation per cycle', 'Single-port RAM has one address port shared for read and write, so only one operation can occur per clock cycle.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (41, 21, 'What is the main advantage of using $readmemh for ROM initialization?', 'multiple_choice', '["Faster access", "Code is cleaner and data can be external", "Uses less memory", "Supports more addresses"]', 'Code is cleaner and data can be external', '$readmemh loads data from an external file, keeping the HDL code clean and allowing data to be maintained separately.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (42, 21, 'Can ROM be inferred as block RAM by synthesis tools?', 'multiple_choice', '["Never", "Only if synchronous", "Only if asynchronous", "Always"]', 'Only if synchronous', 'Synchronous ROM (with clocked output) can be mapped to block RAM. Combinational ROM typically uses LUTs.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (43, 22, 'What is the difference between parameter and localparam?', 'multiple_choice', '["No difference", "parameter can be overridden at instantiation, localparam cannot", "localparam is faster", "parameter is only for ports"]', 'parameter can be overridden at instantiation, localparam cannot', 'Parameters can be overridden when instantiating a module, while localparams are internal constants that cannot be changed.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (44, 22, 'What does $clog2(N) return?', 'multiple_choice', '["N/2", "Log base 2 of N", "N squared", "Square root of N"]', 'Log base 2 of N', '$clog2 returns the ceiling of the logarithm base 2, commonly used to calculate address width needed for N locations.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (45, 23, 'What does a barrel shifter do?', 'multiple_choice', '["Stores data", "Shifts data by a variable amount in one cycle", "Converts serial to parallel", "Counts events"]', 'Shifts data by a variable amount in one cycle', 'A barrel shifter can shift (or rotate) data by any amount in a single clock cycle using a multi-stage MUX network.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (46, 23, 'In a PISO shift register, what does the ''load'' signal do?', 'multiple_choice', '["Clears the register", "Loads parallel data into the shift register", "Enables clock", "Resets the counter"]', 'Loads parallel data into the shift register', 'The load signal captures the parallel input data into the shift register, after which it can be shifted out serially.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (47, 24, 'What is the main benefit of pipelining?', 'multiple_choice', '["Reduces latency", "Increases throughput", "Uses fewer registers", "Simplifies logic"]', 'Increases throughput', 'Pipelining improves throughput by allowing multiple instructions to be in different stages simultaneously, even though each individual instruction takes longer.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (48, 24, 'What must be done to valid/strobe signals in a pipeline?', 'multiple_choice', '["Nothing", "They must be pipelined with data", "They should be combinational", "They must be removed"]', 'They must be pipelined with data', 'Control signals like valid must be delayed through the pipeline to match the data latency, ensuring correct operation.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (49, 25, 'What is the purpose of a self-checking testbench?', 'multiple_choice', '["Generate stimuli only", "Automatically verify expected results", "Reduce simulation time", "Synthesize the design"]', 'Automatically verify expected results', 'Self-checking testbenches compare actual outputs against expected values and report errors automatically.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (50, 25, 'Why use $urandom_range for stimulus generation?', 'multiple_choice', '["It is faster", "Provides constrained random testing", "Generates deterministic results", "Uses less memory"]', 'Provides constrained random testing', 'Random stimulus helps find corner cases that manual testing might miss, while constraints ensure valid inputs.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (51, 26, 'What is the difference between assert and assume?', 'multiple_choice', '["No difference", "assert checks properties, assume constrains inputs", "assume is for formal only", "assert is for simulation only"]', 'assert checks properties, assume constrains inputs', 'Assert properties verify design behavior, while assume properties constrain input behavior for formal verification tools.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (52, 26, 'What does |-> mean in SVA?', 'multiple_choice', '["Or-implies", "Implies", "Followed by", "Equals"]', 'Implies', 'The |-> operator is the overlapping implication operator, meaning if the left side is true, the right side must also be true in the same clock cycle.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (53, 27, 'What is the main advantage of clock gating over clock enable?', 'multiple_choice', '["Simpler design", "Greater power savings", "Better timing", "No clock tree impact"]', 'Greater power savings', 'Clock gating eliminates switching power in the clock tree and logic, providing much greater power savings than just disabling FF updates.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (54, 27, 'Why is a latch used in clock gating?', 'multiple_choice', '["For speed", "To prevent glitches on gated clock", "To store data", "For reset"]', 'To prevent glitches on gated clock', 'The latch holds the enable signal stable during the high phase of the clock, preventing glitches that could cause errors.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (55, 28, 'When can operators be shared?', 'multiple_choice', '["Always", "When operations are mutually exclusive", "Only for addition", "Only in sequential logic"]', 'When operations are mutually exclusive', 'Operators can be shared when only one operation executes at a time, allowing a single hardware unit to serve multiple functions.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (56, 28, 'What is the trade-off of resource sharing?', 'multiple_choice', '["More area, less speed", "Less area, potentially less speed", "More power", "More complexity"]', 'Less area, potentially less speed', 'Resource sharing reduces area by reusing hardware, but may increase latency or reduce throughput if operations must be serialized.', 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (57, 29, 'Which of these is NOT synthesizable?', 'multiple_choice', '["assign", "always_ff", "#delay", "parameter"]', '#delay', 'Delay statements (#) are simulation-only constructs and cannot be synthesized into hardware.', 0)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, quiz_id, question, question_type, options, correct_answer, explanation, order_index)
VALUES (58, 29, 'Can $display be used in synthesizable code?', 'multiple_choice', '["Yes, it synthesizes to display logic", "No, it causes errors", "Synthesis tools ignore it", "Only with special pragma"]', 'Synthesis tools ignore it', 'Synthesis tools silently ignore $display and other system tasks, but it is poor practice to include them in synthesizable code.', 1)
ON CONFLICT (id) DO NOTHING;
SELECT setval(pg_get_serial_sequence('public.quiz_questions', 'id'), COALESCE(MAX(id), 1)) FROM public.quiz_questions;

-- 11. ACHIEVEMENTS
INSERT INTO public.achievements (slug, name, description, icon, xp_reward, condition_type, condition_value) VALUES
('first-step', 'First Step', 'Solve your first problem', '🚀', 25, 'problems_solved', 1),
('getting-started', 'Getting Started', 'Solve 3 problems', '⚡', 50, 'problems_solved', 3),
('hdl-apprentice', 'HDL Apprentice', 'Solve 5 problems', '🛠️', 100, 'problems_solved', 5),
('hdl-expert', 'HDL Expert', 'Solve all 10 problems', '🏆', 250, 'problems_solved', 10),
('combinational-master', 'Combinational Master', 'Solve 3 combinational logic problems', '🔀', 75, 'category_solved', 3),
('sequential-master', 'Sequential Master', 'Solve 2 sequential logic problems', '⏱️', 75, 'category_solved', 2),
('perfectionist', 'Perfectionist', 'Achieve a 100% score on any problem on the first try', '🎯', 50, 'perfect_score', 1),
('streak-3', 'On Fire', 'Solve problems 3 days in a row', '🔥', 60, 'streak', 3)
ON CONFLICT (slug) DO NOTHING;
