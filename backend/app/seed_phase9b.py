"""
Phase 9B — 100-Test Validation Seed for HDLForge.

Creates 10 test cases per problem (100 total).
Each test case is a self-contained testbench that runs ALL 10 test vectors.
Two testbenches per problem: PUBLIC (vectors 1-3) and HIDDEN (vectors 1-10).
"""

import logging
from sqlalchemy.orm import Session
from app.db.database import SessionLocal
from app.db.models import Difficulty, Language, Problem, TestCase, TestVisibility

logger = logging.getLogger(__name__)

# ============================================================================
# REFERENCE IMPLEMENTATIONS (for validation only, never submitted as student code)
# ============================================================================

REFERENCE_IMPLEMENTATIONS = {
    "and_gate": "module and_gate(input logic a, input logic b, output logic y); assign y = a & b; endmodule",
    "or_gate":  "module or_gate(input logic a, input logic b, output logic y); assign y = a | b; endmodule",
    "not_gate": "module not_gate(input logic a, output logic y); assign y = ~a; endmodule",
    "xor_gate": "module xor_gate(input logic a, input logic b, output logic y); assign y = a ^ b; endmodule",
    "mux2":     "module mux2(input logic a, input logic b, input logic sel, output logic y); assign y = sel ? b : a; endmodule",
    "half_adder": "module half_adder(input logic a, input logic b, output logic sum, output logic carry); assign sum = a ^ b; assign carry = a & b; endmodule",
    "full_adder": "module full_adder(input logic a, input logic b, input logic cin, output logic sum, output logic cout); assign {cout, sum} = a + b + cin; endmodule",
    "d_flip_flop": "module d_flip_flop(input logic clk, input logic rst, input logic d, output logic q); always_ff @(posedge clk) begin if (rst) q <= 1'b0; else q <= d; end endmodule",
    "counter": "module counter(input logic clk, input logic rst, output logic [3:0] count); always_ff @(posedge clk) begin if (rst) count <= 4'b0000; else count <= count + 4'b0001; end endmodule",
    "alu": """module alu(input logic [3:0] a, input logic [3:0] b, input logic [1:0] op, output logic [3:0] result);
  always_comb begin
    case (op)
      2'b00: result = a + b;
      2'b01: result = a - b;
      2'b10: result = a & b;
      2'b11: result = a | b;
      default: result = 4'b0000;
    endcase
  end
endmodule""",
}

# Broken implementations for validation testing
BROKEN_IMPLEMENTATIONS = {
    "and_gate_broken_or": "module and_gate(input logic a, input logic b, output logic y); assign y = a | b; endmodule",
    "xor_gate_broken_and": "module xor_gate(input logic a, input logic b, output logic y); assign y = a & b; endmodule",
    "mux2_reversed": "module mux2(input logic a, input logic b, input logic sel, output logic y); assign y = sel ? a : b; endmodule",
    "half_adder_carry_wrong": "module half_adder(input logic a, input logic b, output logic sum, output logic carry); assign sum = a ^ b; assign carry = a | b; endmodule",
    "full_adder_ignores_cin": "module full_adder(input logic a, input logic b, input logic cin, output logic sum, output logic cout); assign {cout, sum} = a + b; endmodule",
    "d_flip_flop_negedge": "module d_flip_flop(input logic clk, input logic rst, input logic d, output logic q); always_ff @(negedge clk) begin if (rst) q <= 1'b0; else q <= d; end endmodule",
    "d_flip_flop_async_reset": "module d_flip_flop(input logic clk, input logic rst, input logic d, output logic q); always_ff @(posedge clk or posedge rst) begin if (rst) q <= 1'b0; else q <= d; end endmodule",
    "counter_no_reset": "module counter(input logic clk, input logic rst, output logic [3:0] count); always_ff @(posedge clk) begin count <= count + 4'b0001; end endmodule",
    "counter_stops_at_15": "module counter(input logic clk, input logic rst, output logic [3:0] count); always_ff @(posedge clk) begin if (rst) count <= 4'b0000; else if (count < 4'b1111) count <= count + 4'b0001; end endmodule",
    "alu_wrong_opcode": "module alu(input logic [3:0] a, input logic [3:0] b, input logic [1:0] op, output logic [3:0] result); always_comb begin case (op) 2'b00: result = a - b; 2'b01: result = a + b; 2'b10: result = a & b; 2'b11: result = a | b; default: result = 4'b0000; endcase end endmodule",
}

# ============================================================================
# TEST VECTOR DEFINITIONS (10 per problem)
# ============================================================================

# AND Gate: y = a & b
AND_GATE_VECTORS = [
    {"a": 0, "b": 0, "y": 0, "name": "a=0,b=0 -> y=0"},
    {"a": 0, "b": 1, "y": 0, "name": "a=0,b=1 -> y=0"},
    {"a": 1, "b": 0, "y": 0, "name": "a=1,b=0 -> y=0"},
    {"a": 1, "b": 1, "y": 1, "name": "a=1,b=1 -> y=1"},
    {"a": 1, "b": 1, "y": 1, "name": "a=1,b=1 -> y=1 (repeat)"},
    {"a": 0, "b": 1, "y": 0, "name": "a=0,b=1 -> y=0 (repeat)"},
    {"a": 1, "b": 0, "y": 0, "name": "a=1,b=0 -> y=0 (repeat)"},
    {"a": 0, "b": 0, "y": 0, "name": "a=0,b=0 -> y=0 (repeat)"},
    {"a": 1, "b": 1, "y": 1, "name": "a=1,b=1 -> y=1 (edge)"},
    {"a": 0, "b": 0, "y": 0, "name": "a=0,b=0 -> y=0 (edge)"},
]

# OR Gate: y = a | b
OR_GATE_VECTORS = [
    {"a": 0, "b": 0, "y": 0, "name": "a=0,b=0 -> y=0"},
    {"a": 0, "b": 1, "y": 1, "name": "a=0,b=1 -> y=1"},
    {"a": 1, "b": 0, "y": 1, "name": "a=1,b=0 -> y=1"},
    {"a": 1, "b": 1, "y": 1, "name": "a=1,b=1 -> y=1"},
    {"a": 1, "b": 1, "y": 1, "name": "a=1,b=1 -> y=1 (repeat)"},
    {"a": 0, "b": 1, "y": 1, "name": "a=0,b=1 -> y=1 (repeat)"},
    {"a": 1, "b": 0, "y": 1, "name": "a=1,b=0 -> y=1 (repeat)"},
    {"a": 0, "b": 0, "y": 0, "name": "a=0,b=0 -> y=0 (repeat)"},
    {"a": 1, "b": 1, "y": 1, "name": "a=1,b=1 -> y=1 (edge)"},
    {"a": 0, "b": 0, "y": 0, "name": "a=0,b=0 -> y=0 (edge)"},
]

# NOT Gate: y = ~a
NOT_GATE_VECTORS = [
    {"a": 0, "y": 1, "name": "a=0 -> y=1"},
    {"a": 1, "y": 0, "name": "a=1 -> y=0"},
    {"a": 0, "y": 1, "name": "a=0 -> y=1 (repeat)"},
    {"a": 1, "y": 0, "name": "a=1 -> y=0 (repeat)"},
    {"a": 1, "y": 0, "name": "a=1 -> y=0 (edge)"},
    {"a": 0, "y": 1, "name": "a=0 -> y=1 (edge)"},
    {"a": 1, "y": 0, "name": "a=1 -> y=0 (final)"},
    {"a": 0, "y": 1, "name": "a=0 -> y=1 (final)"},
    {"a": 0, "y": 1, "name": "a=0 -> y=1 (boundary)"},
    {"a": 1, "y": 0, "name": "a=1 -> y=0 (boundary)"},
]

# XOR Gate: y = a ^ b
XOR_GATE_VECTORS = [
    {"a": 0, "b": 0, "y": 0, "name": "a=0,b=0 -> y=0"},
    {"a": 0, "b": 1, "y": 1, "name": "a=0,b=1 -> y=1"},
    {"a": 1, "b": 0, "y": 1, "name": "a=1,b=0 -> y=1"},
    {"a": 1, "b": 1, "y": 0, "name": "a=1,b=1 -> y=0"},
    {"a": 1, "b": 0, "y": 1, "name": "a=1,b=0 -> y=1 (repeat)"},
    {"a": 0, "b": 1, "y": 1, "name": "a=0,b=1 -> y=1 (repeat)"},
    {"a": 1, "b": 1, "y": 0, "name": "a=1,b=1 -> y=0 (repeat)"},
    {"a": 0, "b": 0, "y": 0, "name": "a=0,b=0 -> y=0 (repeat)"},
    {"a": 1, "b": 1, "y": 0, "name": "a=1,b=1 -> y=0 (edge)"},
    {"a": 0, "b": 0, "y": 0, "name": "a=0,b=0 -> y=0 (edge)"},
]

# 2:1 MUX: y = sel ? b : a
MUX_VECTORS = [
    {"a": 0, "b": 0, "sel": 0, "y": 0, "name": "sel=0,a=0,b=0 -> y=0"},
    {"a": 0, "b": 1, "sel": 0, "y": 0, "name": "sel=0,a=0,b=1 -> y=0"},
    {"a": 1, "b": 0, "sel": 0, "y": 1, "name": "sel=0,a=1,b=0 -> y=1"},
    {"a": 1, "b": 1, "sel": 0, "y": 1, "name": "sel=0,a=1,b=1 -> y=1"},
    {"a": 0, "b": 0, "sel": 1, "y": 0, "name": "sel=1,a=0,b=0 -> y=0"},
    {"a": 0, "b": 1, "sel": 1, "y": 1, "name": "sel=1,a=0,b=1 -> y=1"},
    {"a": 1, "b": 0, "sel": 1, "y": 0, "name": "sel=1,a=1,b=0 -> y=0"},
    {"a": 1, "b": 1, "sel": 1, "y": 1, "name": "sel=1,a=1,b=1 -> y=1"},
    {"a": 1, "b": 0, "sel": 0, "y": 1, "name": "sel=0,a=1,b=0 -> y=1 (edge)"},
    {"a": 0, "b": 1, "sel": 1, "y": 1, "name": "sel=1,a=0,b=1 -> y=1 (edge)"},
]

# Half Adder: sum = a ^ b, carry = a & b
HALF_ADDER_VECTORS = [
    {"a": 0, "b": 0, "sum": 0, "carry": 0, "name": "0+0 -> sum=0,carry=0"},
    {"a": 0, "b": 1, "sum": 1, "carry": 0, "name": "0+1 -> sum=1,carry=0"},
    {"a": 1, "b": 0, "sum": 1, "carry": 0, "name": "1+0 -> sum=1,carry=0"},
    {"a": 1, "b": 1, "sum": 0, "carry": 1, "name": "1+1 -> sum=0,carry=1"},
    {"a": 1, "b": 1, "sum": 0, "carry": 1, "name": "1+1 -> sum=0,carry=1 (repeat)"},
    {"a": 1, "b": 0, "sum": 1, "carry": 0, "name": "1+0 -> sum=1,carry=0 (repeat)"},
    {"a": 0, "b": 1, "sum": 1, "carry": 0, "name": "0+1 -> sum=1,carry=0 (repeat)"},
    {"a": 0, "b": 0, "sum": 0, "carry": 0, "name": "0+0 -> sum=0,carry=0 (repeat)"},
    {"a": 1, "b": 1, "sum": 0, "carry": 1, "name": "1+1 -> sum=0,carry=1 (edge)"},
    {"a": 0, "b": 0, "sum": 0, "carry": 0, "name": "0+0 -> sum=0,carry=0 (edge)"},
]

# Full Adder: {cout, sum} = a + b + cin
FULL_ADDER_VECTORS = [
    {"a": 0, "b": 0, "cin": 0, "sum": 0, "cout": 0, "name": "0+0+0 -> sum=0,cout=0"},
    {"a": 0, "b": 0, "cin": 1, "sum": 1, "cout": 0, "name": "0+0+1 -> sum=1,cout=0"},
    {"a": 0, "b": 1, "cin": 0, "sum": 1, "cout": 0, "name": "0+1+0 -> sum=1,cout=0"},
    {"a": 0, "b": 1, "cin": 1, "sum": 0, "cout": 1, "name": "0+1+1 -> sum=0,cout=1"},
    {"a": 1, "b": 0, "cin": 0, "sum": 1, "cout": 0, "name": "1+0+0 -> sum=1,cout=0"},
    {"a": 1, "b": 0, "cin": 1, "sum": 0, "cout": 1, "name": "1+0+1 -> sum=0,cout=1"},
    {"a": 1, "b": 1, "cin": 0, "sum": 0, "cout": 1, "name": "1+1+0 -> sum=0,cout=1"},
    {"a": 1, "b": 1, "cin": 1, "sum": 1, "cout": 1, "name": "1+1+1 -> sum=1,cout=1"},
    {"a": 1, "b": 1, "cin": 1, "sum": 1, "cout": 1, "name": "1+1+1 -> sum=1,cout=1 (repeat)"},
    {"a": 0, "b": 1, "cin": 1, "sum": 0, "cout": 1, "name": "0+1+1 -> sum=0,cout=1 (edge)"},
]

# D Flip-Flop: posedge clk, sync rst
DFF_VECTORS = [
    {"rst": 1, "d": 0, "q": 0, "name": "rst=1,d=0 -> q=0"},
    {"rst": 1, "d": 1, "q": 0, "name": "rst=1,d=1 -> q=0 (rst overrides)"},
    {"rst": 0, "d": 0, "q": 0, "name": "rst=0,d=0 -> q=0"},
    {"rst": 0, "d": 1, "q": 1, "name": "rst=0,d=1 -> q=1"},
    {"rst": 0, "d": 0, "q": 0, "name": "rst=0,d=0 -> q=0 (toggle)"},
    {"rst": 0, "d": 1, "q": 1, "name": "rst=0,d=1 -> q=1 (toggle)"},
    {"rst": 1, "d": 1, "q": 0, "name": "rst=1,d=1 -> q=0 (reset mid-op)"},
    {"rst": 1, "d": 0, "q": 0, "name": "rst=1,d=0 -> q=0 (reset hold)"},
    {"rst": 0, "d": 1, "q": 1, "name": "rst=0,d=1 -> q=1 (after reset)"},
    {"rst": 0, "d": 0, "q": 0, "name": "rst=0,d=0 -> q=0 (final)"},
]

# 4-bit Counter: sync rst, count = count + 1, wraps 15->0
COUNTER_VECTORS = [
    {"rst": 1, "count": 0, "name": "rst -> count=0"},
    {"rst": 0, "count": 1, "name": "count=1"},
    {"rst": 0, "count": 2, "name": "count=2"},
    {"rst": 0, "count": 3, "name": "count=3"},
    {"rst": 0, "count": 14, "name": "count=14 (near max)"},
    {"rst": 0, "count": 15, "name": "count=15 (max)"},
    {"rst": 0, "count": 0, "name": "count=0 (wrap from 15)"},
    {"rst": 0, "count": 1, "name": "count=1 (after wrap)"},
    {"rst": 1, "count": 0, "name": "rst after counting -> count=0"},
    {"rst": 0, "count": 1, "name": "count=1 (resume after reset)"},
]

# ALU: op 00=ADD, 01=SUB, 10=AND, 11=OR (4-bit results)
ALU_VECTORS = [
    {"a": 3, "b": 2, "op": 0, "result": 5, "name": "ADD 3+2=5"},
    {"a": 7, "b": 4, "op": 0, "result": 11, "name": "ADD 7+4=11"},
    {"a": 15, "b": 1, "op": 0, "result": 0, "name": "ADD 15+1=0 (overflow)"},
    {"a": 7, "b": 3, "op": 1, "result": 4, "name": "SUB 7-3=4"},
    {"a": 3, "b": 7, "op": 1, "result": 12, "name": "SUB 3-7=12 (underflow)"},
    {"a": 15, "b": 15, "op": 1, "result": 0, "name": "SUB 15-15=0"},
    {"a": 12, "b": 10, "op": 2, "result": 8, "name": "AND 0xC & 0xA = 0x8"},
    {"a": 5, "b": 10, "op": 2, "result": 0, "name": "AND 0x5 & 0xA = 0x0"},
    {"a": 12, "b": 10, "op": 3, "result": 14, "name": "OR 0xC | 0xA = 0xE"},
    {"a": 5, "b": 10, "op": 3, "result": 15, "name": "OR 0x5 | 0xA = 0xF"},
]

# ============================================================================
# TESTBENCH GENERATORS
# ============================================================================

def _gen_combinational_tb(module_name: str, ports_decl: str, inst_ports: str,
                          vectors: list[dict], check_expr: str) -> str:
    """Generate a combinational testbench that runs all vectors.
    Uses always blocks with posedge/negedge clk for Verilator 4.x compatibility."""
    score_divisor = len(vectors)
    n = len(vectors)

    # Collect unique port names (excluding y, name)
    port_keys = [k for k in vectors[0] if k not in ("y", "name")]

    lines = [
        "module testbench;",
        f"  {ports_decl}",
        f"  {module_name} uut ({inst_ports});",
        "  reg clk = 0;",
        "  always #5 clk = ~clk;",
        "  int idx = 0;",
        "  int pass_count = 0;",
    ]

    # Declare arrays for each port and expected output
    for pk in port_keys:
        lines.append(f"  logic [{n-1}:0] vec_{pk};")
    lines.append(f"  logic [{n-1}:0] vec_y;")

    # Fill arrays
    lines.append("  initial begin")
    for i, v in enumerate(vectors):
        for pk in port_keys:
            lines.append(f"    vec_{pk}[{i}] = {v[pk]};")
        lines.append(f"    vec_y[{i}] = {v['y']};")
    lines.append("  end")

    lines += [
        '  task automatic check(input logic exp, input string label);',
        '    if (y === exp) begin',
        '      $display("HDLFORGE_TEST_NAME:%s", label);',
        '      $display("HDLFORGE_TEST_PASS");',
        "      pass_count++;",
        "    end else begin",
        '      $display("HDLFORGE_TEST_NAME:%s", label);',
        '      $display("HDLFORGE_EXPECTED:%b", exp);',
        '      $display("HDLFORGE_RECEIVED:%b", y);',
        '      $display("HDLFORGE_TEST_FAIL");',
        "    end",
        "  endtask",
        "  always @(posedge clk) begin",
        "    case (idx)",
    ]
    for i, v in enumerate(vectors):
        assigns = "; ".join(f"{pk} = vec_{pk}[{i}]" for pk in port_keys)
        lines.append(f"      {i}: begin {assigns}; end")
    lines += [
        "    endcase",
        "    idx <= idx + 1;",
        "  end",
        "  always @(negedge clk) begin",
        "    case (idx)",
    ]
    for i, v in enumerate(vectors):
        lines.append(f'      {i+1}: check(1\'b{v["y"]}, "{v["name"]}");')
    lines += [
        "    endcase",
        f"    if (idx == {n}) begin",
        f'      $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / {score_divisor});',
        "      $finish;",
        "    end",
        "  end",
        "endmodule",
    ]
    return "\n".join(lines)


def _gen_and_gate_tb(vectors: list[dict]) -> str:
    return _gen_combinational_tb(
        "and_gate",
        "logic a, b, y;",
        ".a(a), .b(b), .y(y)",
        vectors,
        "y",
    )


def _gen_or_gate_tb(vectors: list[dict]) -> str:
    return _gen_combinational_tb(
        "or_gate",
        "logic a, b, y;",
        ".a(a), .b(b), .y(y)",
        vectors,
        "y",
    )


def _gen_not_gate_tb(vectors: list[dict]) -> str:
    n = len(vectors)
    lines = [
        "module testbench;",
        "  logic a, y;",
        "  not_gate uut (.a(a), .y(y));",
        "  reg clk = 0;",
        "  always #5 clk = ~clk;",
        f"  logic [{n-1}:0] vec_a;",
        f"  logic [{n-1}:0] vec_y;",
        "  int idx = 0;",
        "  int pass_count = 0;",
    ]
    lines.append("  initial begin")
    for i, v in enumerate(vectors):
        lines.append(f'    vec_a[{i}] = {v["a"]}; vec_y[{i}] = {v["y"]};')
    lines.append("  end")
    lines += [
        '  task automatic check(input logic exp, input string label);',
        '    if (y === exp) begin',
        '      $display("HDLFORGE_TEST_NAME:%s", label);',
        '      $display("HDLFORGE_TEST_PASS");',
        "      pass_count++;",
        "    end else begin",
        '      $display("HDLFORGE_TEST_NAME:%s", label);',
        '      $display("HDLFORGE_EXPECTED:%b", exp);',
        '      $display("HDLFORGE_RECEIVED:%b", y);',
        '      $display("HDLFORGE_TEST_FAIL");',
        "    end",
        "  endtask",
        "  always @(posedge clk) begin",
        "    case (idx)",
    ]
    for i in range(n):
        lines.append(f"      {i}: a = vec_a[{i}];")
    lines += [
        "    endcase",
        "    idx <= idx + 1;",
        "  end",
        "  always @(negedge clk) begin",
        "    case (idx)",
    ]
    for i, v in enumerate(vectors):
        lines.append(f'      {i+1}: check(1\'b{v["y"]}, "{v["name"]}");')
    lines += [
        "    endcase",
        f"    if (idx == {n}) begin",
        f'      $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / {n});',
        "      $finish;",
        "    end",
        "  end",
        "endmodule",
    ]
    return "\n".join(lines)


def _gen_xor_gate_tb(vectors: list[dict]) -> str:
    return _gen_combinational_tb(
        "xor_gate",
        "logic a, b, y;",
        ".a(a), .b(b), .y(y)",
        vectors,
        "y",
    )


def _gen_mux_tb(vectors: list[dict]) -> str:
    n = len(vectors)
    lines = [
        "module testbench;",
        "  logic a, b, sel, y;",
        "  mux2 uut (.a(a), .b(b), .sel(sel), .y(y));",
        "  reg clk = 0;",
        "  always #5 clk = ~clk;",
        f"  logic [{n-1}:0] vec_a, vec_b, vec_sel, vec_y;",
        "  int idx = 0;",
        "  int pass_count = 0;",
    ]
    lines.append("  initial begin")
    for i, v in enumerate(vectors):
        lines.append(f'    vec_a[{i}] = {v["a"]}; vec_b[{i}] = {v["b"]}; vec_sel[{i}] = {v["sel"]}; vec_y[{i}] = {v["y"]};')
    lines.append("  end")
    lines += [
        '  task automatic check(input logic exp, input string label);',
        '    if (y === exp) begin',
        '      $display("HDLFORGE_TEST_NAME:%s", label);',
        '      $display("HDLFORGE_TEST_PASS");',
        "      pass_count++;",
        "    end else begin",
        '      $display("HDLFORGE_TEST_NAME:%s", label);',
        '      $display("HDLFORGE_EXPECTED:%b", exp);',
        '      $display("HDLFORGE_RECEIVED:%b", y);',
        '      $display("HDLFORGE_TEST_FAIL");',
        "    end",
        "  endtask",
        "  always @(posedge clk) begin",
        "    case (idx)",
    ]
    for i in range(n):
        lines.append(f"      {i}: begin a = vec_a[{i}]; b = vec_b[{i}]; sel = vec_sel[{i}]; end")
    lines += [
        "    endcase",
        "    idx <= idx + 1;",
        "  end",
        "  always @(negedge clk) begin",
        "    case (idx)",
    ]
    for i, v in enumerate(vectors):
        lines.append(f'      {i+1}: check(1\'b{v["y"]}, "{v["name"]}");')
    lines += [
        "    endcase",
        f"    if (idx == {n}) begin",
        f'      $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / {n});',
        "      $finish;",
        "    end",
        "  end",
        "endmodule",
    ]
    return "\n".join(lines)


def _gen_half_adder_tb(vectors: list[dict]) -> str:
    n = len(vectors)
    lines = [
        "module testbench;",
        "  logic a, b, sum, carry;",
        "  half_adder uut (.a(a), .b(b), .sum(sum), .carry(carry));",
        "  reg clk = 0;",
        "  always #5 clk = ~clk;",
        f"  logic [{n-1}:0] vec_a, vec_b, vec_sum, vec_carry;",
        "  int idx = 0;",
        "  int pass_count = 0;",
    ]
    lines.append("  initial begin")
    for i, v in enumerate(vectors):
        lines.append(f'    vec_a[{i}] = {v["a"]}; vec_b[{i}] = {v["b"]}; vec_sum[{i}] = {v["sum"]}; vec_carry[{i}] = {v["carry"]};')
    lines.append("  end")
    lines += [
        '  task automatic check(input logic exp_sum, input logic exp_carry, input string label);',
        '    if (sum === exp_sum && carry === exp_carry) begin',
        '      $display("HDLFORGE_TEST_NAME:%s", label);',
        '      $display("HDLFORGE_TEST_PASS");',
        "      pass_count++;",
        "    end else begin",
        '      $display("HDLFORGE_TEST_NAME:%s", label);',
        '      $display("HDLFORGE_EXPECTED:sum=%b,carry=%b", exp_sum, exp_carry);',
        '      $display("HDLFORGE_RECEIVED:sum=%b,carry=%b", sum, carry);',
        '      $display("HDLFORGE_TEST_FAIL");',
        "    end",
        "  endtask",
        "  always @(posedge clk) begin",
        "    case (idx)",
    ]
    for i in range(n):
        lines.append(f"      {i}: begin a = vec_a[{i}]; b = vec_b[{i}]; end")
    lines += [
        "    endcase",
        "    idx <= idx + 1;",
        "  end",
        "  always @(negedge clk) begin",
        "    case (idx)",
    ]
    for i, v in enumerate(vectors):
        lines.append(f'      {i+1}: check(1\'b{v["sum"]}, 1\'b{v["carry"]}, "{v["name"]}");')
    lines += [
        "    endcase",
        f"    if (idx == {n}) begin",
        f'      $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / {n});',
        "      $finish;",
        "    end",
        "  end",
        "endmodule",
    ]
    return "\n".join(lines)


def _gen_full_adder_tb(vectors: list[dict]) -> str:
    n = len(vectors)
    lines = [
        "module testbench;",
        "  logic a, b, cin, sum, cout;",
        "  full_adder uut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));",
        "  reg clk = 0;",
        "  always #5 clk = ~clk;",
        f"  logic [{n-1}:0] vec_a, vec_b, vec_cin, vec_sum, vec_cout;",
        "  int idx = 0;",
        "  int pass_count = 0;",
    ]
    lines.append("  initial begin")
    for i, v in enumerate(vectors):
        lines.append(f'    vec_a[{i}] = {v["a"]}; vec_b[{i}] = {v["b"]}; vec_cin[{i}] = {v["cin"]}; vec_sum[{i}] = {v["sum"]}; vec_cout[{i}] = {v["cout"]};')
    lines.append("  end")
    lines += [
        '  task automatic check(input logic exp_sum, input logic exp_cout, input string label);',
        '    if (sum === exp_sum && cout === exp_cout) begin',
        '      $display("HDLFORGE_TEST_NAME:%s", label);',
        '      $display("HDLFORGE_TEST_PASS");',
        "      pass_count++;",
        "    end else begin",
        '      $display("HDLFORGE_TEST_NAME:%s", label);',
        '      $display("HDLFORGE_EXPECTED:sum=%b,cout=%b", exp_sum, exp_cout);',
        '      $display("HDLFORGE_RECEIVED:sum=%b,cout=%b", sum, cout);',
        '      $display("HDLFORGE_TEST_FAIL");',
        "    end",
        "  endtask",
        "  always @(posedge clk) begin",
        "    case (idx)",
    ]
    for i in range(n):
        lines.append(f"      {i}: begin a = vec_a[{i}]; b = vec_b[{i}]; cin = vec_cin[{i}]; end")
    lines += [
        "    endcase",
        "    idx <= idx + 1;",
        "  end",
        "  always @(negedge clk) begin",
        "    case (idx)",
    ]
    for i, v in enumerate(vectors):
        lines.append(f'      {i+1}: check(1\'b{v["sum"]}, 1\'b{v["cout"]}, "{v["name"]}");')
    lines += [
        "    endcase",
        f"    if (idx == {n}) begin",
        f'      $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / {n});',
        "      $finish;",
        "    end",
        "  end",
        "endmodule",
    ]
    return "\n".join(lines)


def _gen_dff_tb(vectors: list[dict]) -> str:
    lines = [
        "module testbench;",
        "  logic clk, rst, d, q;",
        "  d_flip_flop uut (.clk(clk), .rst(rst), .d(d), .q(q));",
        "  initial clk = 0;",
        "  always #5 clk = ~clk;",
        "  int pass_count = 0;",
        "  int total_count = 0;",
        '  task automatic check(input logic exp, input string name);',
        "    total_count++;",
        "    if (q === exp) begin",
        '      $display("HDLFORGE_TEST_NAME:%s", name);',
        '      $display("HDLFORGE_TEST_PASS");',
        "      pass_count++;",
        "    end else begin",
        '      $display("HDLFORGE_TEST_NAME:%s", name);',
        '      $display("HDLFORGE_EXPECTED:%b", exp);',
        '      $display("HDLFORGE_RECEIVED:%b", q);',
        '      $display("HDLFORGE_TEST_FAIL");',
        "    end",
        "  endtask",
        "  initial begin",
    ]
    for i, v in enumerate(vectors):
        lines.append(f'    rst = {v["rst"]}; d = {v["d"]}; @(posedge clk) #1;')
        lines.append(f'    check(1\'b{v["q"]}, "{v["name"]}");')
    lines.append(f'    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / {len(vectors)});')
    lines.append("    $finish;")
    lines.append("  end")
    lines.append("endmodule")
    return "\n".join(lines)


def _gen_counter_tb(vectors: list[dict]) -> str:
    lines = [
        "module testbench;",
        "  logic clk, rst;",
        "  logic [3:0] count;",
        "  counter uut (.clk(clk), .rst(rst), .count(count));",
        "  initial clk = 0;",
        "  always #5 clk = ~clk;",
        "  int pass_count = 0;",
        "  int total_count = 0;",
        '  task automatic check(input logic [3:0] exp, input string name);',
        "    total_count++;",
        "    if (count === exp) begin",
        '      $display("HDLFORGE_TEST_NAME:%s", name);',
        '      $display("HDLFORGE_TEST_PASS");',
        "      pass_count++;",
        "    end else begin",
        '      $display("HDLFORGE_TEST_NAME:%s", name);',
        '      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);',
        '      $display("HDLFORGE_RECEIVED:%0d (0b%b)", count, count);',
        '      $display("HDLFORGE_TEST_FAIL");',
        "    end",
        "  endtask",
        "  initial begin",
    ]
    prev_count = None
    for v in vectors:
        rst = v["rst"]
        target = v["count"]
        name = v["name"]
        if rst:
            lines.append(f'    rst = 1; @(posedge clk) #1;')
            lines.append(f'    check(4\'b0000, "{name}");')
            prev_count = 0
        else:
            if prev_count is None:
                lines.append(f'    rst = 0; @(posedge clk) #1;')
                prev_count = 0
            diff = (target - prev_count) % 16
            if diff == 0 and target == 0:
                lines.append(f'    @(posedge clk) #1;')
            else:
                for _ in range(diff):
                    lines.append(f'    @(posedge clk) #1;')
            lines.append(f'    check(4\'d{target}, "{name}");')
            prev_count = target
    lines.append(f'    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / {len(vectors)});')
    lines.append("    $finish;")
    lines.append("  end")
    lines.append("endmodule")
    return "\n".join(lines)


def _gen_alu_tb(vectors: list[dict]) -> str:
    lines = [
        "module testbench;",
        "  logic [3:0] a, b;",
        "  logic [1:0] op;",
        "  logic [3:0] result;",
        "  alu uut (.a(a), .b(b), .op(op), .result(result));",
        "  reg clk = 0;",
        "  always #5 clk = ~clk;",
        "  int pass_count = 0;",
        "  int total_count = 0;",
        '  task automatic check(input logic [3:0] exp, input string name);',
        "    total_count++;",
        "    if (result === exp) begin",
        '      $display("HDLFORGE_TEST_NAME:%s", name);',
        '      $display("HDLFORGE_TEST_PASS");',
        "      pass_count++;",
        "    end else begin",
        '      $display("HDLFORGE_TEST_NAME:%s", name);',
        '      $display("HDLFORGE_EXPECTED:%0d (0b%b)", exp, exp);',
        '      $display("HDLFORGE_RECEIVED:%0d (0b%b)", result, result);',
        '      $display("HDLFORGE_TEST_FAIL");',
        "    end",
        "  endtask",
        "  initial begin",
    ]
    for v in vectors:
        op_names = {0: "ADD", 1: "SUB", 2: "AND", 3: "OR"}
        lines.append(f'    a = 4\'d{v["a"]}; b = 4\'d{v["b"]}; op = 2\'d{v["op"]}; @(posedge clk) #1;')
        lines.append(f'    check(4\'d{v["result"]}, "{v["name"]}");')
    lines.append(f'    $display("HDLFORGE_SCORE:%0d", (pass_count * 100) / {len(vectors)});')
    lines.append("    $finish;")
    lines.append("  end")
    lines.append("endmodule")
    return "\n".join(lines)


# ============================================================================
# PROBLEM DEFINITIONS (actual module/port names from seed.py)
# ============================================================================

SEED_PROBLEMS = [
    {
        "slug": "and-gate",
        "title": "AND Gate",
        "difficulty": Difficulty.EASY,
        "category": "Combinational Logic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a 2-input AND gate. The output should be 1 only when both inputs are 1.",
        "input_description": "a, b — single-bit inputs",
        "output_description": "y — single-bit output",
        "constraints": "Both inputs are single-bit values.",
        "starter_code": "module and_gate (\n  input  logic a,\n  input  logic b,\n  output logic y\n);\n\n  // Your code here\n\nendmodule",
        "time_complexity": "O(1)",
        "space_complexity": "O(1)",
        "reference_solution": "module and_gate(input logic a, input logic b, output logic y);\n  assign y = a & b;\nendmodule",
    },
    {
        "slug": "or-gate",
        "title": "OR Gate",
        "difficulty": Difficulty.EASY,
        "category": "Combinational Logic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a 2-input OR gate. The output should be 1 when at least one input is 1.",
        "input_description": "a, b — single-bit inputs",
        "output_description": "y — single-bit output",
        "constraints": "Both inputs are single-bit values.",
        "starter_code": "module or_gate (\n  input  logic a,\n  input  logic b,\n  output logic y\n);\n\n  // Your code here\n\nendmodule",
        "time_complexity": "O(1)",
        "space_complexity": "O(1)",
        "reference_solution": "module or_gate(input logic a, input logic b, output logic y);\n  assign y = a | b;\nendmodule",
    },
    {
        "slug": "not-gate",
        "title": "NOT Gate",
        "difficulty": Difficulty.EASY,
        "category": "Combinational Logic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a NOT gate (inverter). The output should be the inverse of the input.",
        "input_description": "a — single-bit input",
        "output_description": "y — single-bit output",
        "constraints": "Input is a single-bit value.",
        "starter_code": "module not_gate (\n  input  logic a,\n  output logic y\n);\n\n  // Your code here\n\nendmodule",
        "time_complexity": "O(1)",
        "space_complexity": "O(1)",
        "reference_solution": "module not_gate(input logic a, output logic y);\n  assign y = ~a;\nendmodule",
    },
    {
        "slug": "xor-gate",
        "title": "XOR Gate",
        "difficulty": Difficulty.EASY,
        "category": "Combinational Logic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a 2-input XOR gate. The output should be 1 when the inputs are different.",
        "input_description": "a, b — single-bit inputs",
        "output_description": "y — single-bit output",
        "constraints": "Both inputs are single-bit values.",
        "starter_code": "module xor_gate (\n  input  logic a,\n  input  logic b,\n  output logic y\n);\n\n  // Your code here\n\nendmodule",
        "time_complexity": "O(1)",
        "space_complexity": "O(1)",
        "reference_solution": "module xor_gate(input logic a, input logic b, output logic y);\n  assign y = a ^ b;\nendmodule",
    },
    {
        "slug": "2-to-1-mux",
        "title": "2:1 Multiplexer",
        "difficulty": Difficulty.EASY,
        "category": "Combinational Logic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a 2-to-1 multiplexer. When sel is 0, output a; when sel is 1, output b.",
        "input_description": "a, b — single-bit inputs, sel — select signal",
        "output_description": "y — single-bit output",
        "constraints": "All inputs are single-bit values.",
        "starter_code": "module mux2 (\n  input  logic a,\n  input  logic b,\n  input  logic sel,\n  output logic y\n);\n\n  // Your code here\n\nendmodule",
        "time_complexity": "O(1)",
        "space_complexity": "O(1)",
        "reference_solution": "module mux2(input logic a, input logic b, input logic sel, output logic y);\n  assign y = sel ? b : a;\nendmodule",
    },
    {
        "slug": "half-adder",
        "title": "Half Adder",
        "difficulty": Difficulty.EASY,
        "category": "Arithmetic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a half adder that adds two single-bit inputs producing sum and carry outputs.",
        "input_description": "a, b — single-bit inputs",
        "output_description": "sum, carry — single-bit outputs",
        "constraints": "Both inputs are single-bit values.",
        "starter_code": "module half_adder (\n  input  logic a,\n  input  logic b,\n  output logic sum,\n  output logic carry\n);\n\n  // Your code here\n\nendmodule",
        "time_complexity": "O(1)",
        "space_complexity": "O(1)",
        "reference_solution": "module half_adder(input logic a, input logic b, output logic sum, output logic carry);\n  assign sum = a ^ b;\n  assign carry = a & b;\nendmodule",
    },
    {
        "slug": "full-adder",
        "title": "Full Adder",
        "difficulty": Difficulty.EASY,
        "category": "Arithmetic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a full adder that adds two single-bit inputs plus a carry-in, producing sum and carry-out.",
        "input_description": "a, b — single-bit inputs, cin — carry-in",
        "output_description": "sum, cout — single-bit outputs",
        "constraints": "All inputs are single-bit values.",
        "starter_code": "module full_adder (\n  input  logic a,\n  input  logic b,\n  input  logic cin,\n  output logic sum,\n  output logic cout\n);\n\n  // Your code here\n\nendmodule",
        "time_complexity": "O(1)",
        "space_complexity": "O(1)",
        "reference_solution": "module full_adder(input logic a, input logic b, input logic cin, output logic sum, output logic cout);\n  assign {cout, sum} = a + b + cin;\nendmodule",
    },
    {
        "slug": "d-flip-flop",
        "title": "D Flip-Flop",
        "difficulty": Difficulty.EASY,
        "category": "Sequential Logic",
        "language": Language.SYSTEMVERILOG,
        "description": "Implement a positive-edge-triggered D flip-flop. On the rising edge of clk, the output q captures the input d. Reset is synchronous and active high.",
        "input_description": "clk — clock signal, d — data input, rst — synchronous reset",
        "output_description": "q — registered output",
        "constraints": "Reset is active high and synchronous.",
        "starter_code": "module d_flip_flop (\n  input  logic clk,\n  input  logic rst,\n  input  logic d,\n  output logic q\n);\n\n  // Your code here\n\nendmodule",
        "time_complexity": "O(1)",
        "space_complexity": "O(1)",
        "reference_solution": "module d_flip_flop(input logic clk, input logic rst, input logic d, output logic q);\n  always_ff @(posedge clk) begin\n    if (rst) q <= 1'b0;\n    else q <= d;\n  end\nendmodule",
    },
    {
        "slug": "4-bit-counter",
        "title": "4-bit Counter",
        "difficulty": Difficulty.MEDIUM,
        "category": "Sequential Logic",
        "language": Language.SYSTEMVERILOG,
        "description": "Design a synchronous 4-bit counter. The counter should reset to 0 when rst is asserted, increment on every rising edge of clk, and wrap from 15 back to 0.",
        "input_description": "clk — clock signal, rst — synchronous active-high reset",
        "output_description": "count[3:0] — 4-bit counter output",
        "constraints": "Reset is synchronous and active high. Counter wraps from 15 to 0.",
        "starter_code": "module counter (\n  input  logic        clk,\n  input  logic        rst,\n  output logic [3:0]  count\n);\n\n  always_ff @(posedge clk) begin\n    if (rst)\n      count <= 4'b0000;\n    else\n      count <= count + 1'b1;\n  end\n\nendmodule",
        "time_complexity": "O(1)",
        "space_complexity": "O(1)",
        "reference_solution": "module counter(input logic clk, input logic rst, output logic [3:0] count);\n  always_ff @(posedge clk) begin\n    if (rst) count <= 4'b0000;\n    else count <= count + 4'b0001;\n  end\nendmodule",
    },
    {
        "slug": "4-bit-alu",
        "title": "ALU",
        "difficulty": Difficulty.MEDIUM,
        "category": "Arithmetic",
        "language": Language.SYSTEMVERILOG,
        "description": "Design a simple 4-bit arithmetic logic unit. The ALU should support addition, subtraction, AND, and OR operations based on a 2-bit opcode.",
        "input_description": "a[3:0], b[3:0] — operands, op[1:0] — opcode (00=ADD, 01=SUB, 10=AND, 11=OR)",
        "output_description": "result[3:0] — operation result",
        "constraints": "All operands are 4-bit values.",
        "starter_code": "module alu (\n  input  logic [3:0] a,\n  input  logic [3:0] b,\n  input  logic [1:0] op,\n  output logic [3:0] result\n);\n\n  // Your code here\n\nendmodule",
        "time_complexity": "O(1)",
        "space_complexity": "O(1)",
        "reference_solution": "module alu(input logic [3:0] a, input logic [3:0] b, input logic [1:0] op, output logic [3:0] result);\n  always_comb begin\n    case (op)\n      2'b00: result = a + b;\n      2'b01: result = a - b;\n      2'b10: result = a & b;\n      2'b11: result = a | b;\n      default: result = 4'b0000;\n    endcase\n  end\nendmodule",
    },
]

# ============================================================================
# TESTBENCHES: PUBLIC (vectors 1-3) and HIDDEN (vectors 1-10)
# ============================================================================

PUBLIC_TESTBENCHES = {
    "and-gate": _gen_and_gate_tb(AND_GATE_VECTORS[:3]),
    "or-gate":  _gen_or_gate_tb(OR_GATE_VECTORS[:3]),
    "not-gate": _gen_not_gate_tb(NOT_GATE_VECTORS[:3]),
    "xor-gate": _gen_xor_gate_tb(XOR_GATE_VECTORS[:3]),
    "2-to-1-mux": _gen_mux_tb(MUX_VECTORS[:3]),
    "half-adder": _gen_half_adder_tb(HALF_ADDER_VECTORS[:3]),
    "full-adder": _gen_full_adder_tb(FULL_ADDER_VECTORS[:3]),
    "d-flip-flop": _gen_dff_tb(DFF_VECTORS[:3]),
    "4-bit-counter": _gen_counter_tb(COUNTER_VECTORS[:3]),
    "4-bit-alu": _gen_alu_tb(ALU_VECTORS[:3]),
}

HIDDEN_TESTBENCHES = {
    "and-gate": _gen_and_gate_tb(AND_GATE_VECTORS),
    "or-gate":  _gen_or_gate_tb(OR_GATE_VECTORS),
    "not-gate": _gen_not_gate_tb(NOT_GATE_VECTORS),
    "xor-gate": _gen_xor_gate_tb(XOR_GATE_VECTORS),
    "2-to-1-mux": _gen_mux_tb(MUX_VECTORS),
    "half-adder": _gen_half_adder_tb(HALF_ADDER_VECTORS),
    "full-adder": _gen_full_adder_tb(FULL_ADDER_VECTORS),
    "d-flip-flop": _gen_dff_tb(DFF_VECTORS),
    "4-bit-counter": _gen_counter_tb(COUNTER_VECTORS),
    "4-bit-alu": _gen_alu_tb(ALU_VECTORS),
}

# ============================================================================
# TEST CASE CONFIGURATION: 10 per problem (2 PUBLIC + 8 HIDDEN)
# ============================================================================

TEST_CASES_CONFIG = {
    "and-gate": [
        {"name": "vectors 1-3 (basic)", "visibility": "PUBLIC", "weight": 0.10, "order": 1},
        {"name": "vectors 1-3 (verify)", "visibility": "PUBLIC", "weight": 0.10, "order": 2},
        {"name": "vectors 1-10 (full)", "visibility": "HIDDEN", "weight": 0.10, "order": 3},
        {"name": "vectors 1-10 (repeat)", "visibility": "HIDDEN", "weight": 0.10, "order": 4},
        {"name": "vectors 1-10 (edge)", "visibility": "HIDDEN", "weight": 0.10, "order": 5},
        {"name": "vectors 1-10 (stress)", "visibility": "HIDDEN", "weight": 0.10, "order": 6},
        {"name": "vectors 1-10 (final-a)", "visibility": "HIDDEN", "weight": 0.10, "order": 7},
        {"name": "vectors 1-10 (final-b)", "visibility": "HIDDEN", "weight": 0.10, "order": 8},
        {"name": "vectors 1-10 (final-c)", "visibility": "HIDDEN", "weight": 0.10, "order": 9},
        {"name": "vectors 1-10 (final-d)", "visibility": "HIDDEN", "weight": 0.10, "order": 10},
    ],
    "or-gate": [
        {"name": "vectors 1-3 (basic)", "visibility": "PUBLIC", "weight": 0.10, "order": 1},
        {"name": "vectors 1-3 (verify)", "visibility": "PUBLIC", "weight": 0.10, "order": 2},
        {"name": "vectors 1-10 (full)", "visibility": "HIDDEN", "weight": 0.10, "order": 3},
        {"name": "vectors 1-10 (repeat)", "visibility": "HIDDEN", "weight": 0.10, "order": 4},
        {"name": "vectors 1-10 (edge)", "visibility": "HIDDEN", "weight": 0.10, "order": 5},
        {"name": "vectors 1-10 (stress)", "visibility": "HIDDEN", "weight": 0.10, "order": 6},
        {"name": "vectors 1-10 (final-a)", "visibility": "HIDDEN", "weight": 0.10, "order": 7},
        {"name": "vectors 1-10 (final-b)", "visibility": "HIDDEN", "weight": 0.10, "order": 8},
        {"name": "vectors 1-10 (final-c)", "visibility": "HIDDEN", "weight": 0.10, "order": 9},
        {"name": "vectors 1-10 (final-d)", "visibility": "HIDDEN", "weight": 0.10, "order": 10},
    ],
    "not-gate": [
        {"name": "vectors 1-3 (basic)", "visibility": "PUBLIC", "weight": 0.10, "order": 1},
        {"name": "vectors 1-3 (verify)", "visibility": "PUBLIC", "weight": 0.10, "order": 2},
        {"name": "vectors 1-10 (full)", "visibility": "HIDDEN", "weight": 0.10, "order": 3},
        {"name": "vectors 1-10 (repeat)", "visibility": "HIDDEN", "weight": 0.10, "order": 4},
        {"name": "vectors 1-10 (edge)", "visibility": "HIDDEN", "weight": 0.10, "order": 5},
        {"name": "vectors 1-10 (stress)", "visibility": "HIDDEN", "weight": 0.10, "order": 6},
        {"name": "vectors 1-10 (final-a)", "visibility": "HIDDEN", "weight": 0.10, "order": 7},
        {"name": "vectors 1-10 (final-b)", "visibility": "HIDDEN", "weight": 0.10, "order": 8},
        {"name": "vectors 1-10 (final-c)", "visibility": "HIDDEN", "weight": 0.10, "order": 9},
        {"name": "vectors 1-10 (final-d)", "visibility": "HIDDEN", "weight": 0.10, "order": 10},
    ],
    "xor-gate": [
        {"name": "vectors 1-3 (basic)", "visibility": "PUBLIC", "weight": 0.10, "order": 1},
        {"name": "vectors 1-3 (verify)", "visibility": "PUBLIC", "weight": 0.10, "order": 2},
        {"name": "vectors 1-10 (full)", "visibility": "HIDDEN", "weight": 0.10, "order": 3},
        {"name": "vectors 1-10 (repeat)", "visibility": "HIDDEN", "weight": 0.10, "order": 4},
        {"name": "vectors 1-10 (edge)", "visibility": "HIDDEN", "weight": 0.10, "order": 5},
        {"name": "vectors 1-10 (stress)", "visibility": "HIDDEN", "weight": 0.10, "order": 6},
        {"name": "vectors 1-10 (final-a)", "visibility": "HIDDEN", "weight": 0.10, "order": 7},
        {"name": "vectors 1-10 (final-b)", "visibility": "HIDDEN", "weight": 0.10, "order": 8},
        {"name": "vectors 1-10 (final-c)", "visibility": "HIDDEN", "weight": 0.10, "order": 9},
        {"name": "vectors 1-10 (final-d)", "visibility": "HIDDEN", "weight": 0.10, "order": 10},
    ],
    "2-to-1-mux": [
        {"name": "vectors 1-3 (basic)", "visibility": "PUBLIC", "weight": 0.10, "order": 1},
        {"name": "vectors 1-3 (verify)", "visibility": "PUBLIC", "weight": 0.10, "order": 2},
        {"name": "vectors 1-10 (full)", "visibility": "HIDDEN", "weight": 0.10, "order": 3},
        {"name": "vectors 1-10 (repeat)", "visibility": "HIDDEN", "weight": 0.10, "order": 4},
        {"name": "vectors 1-10 (edge)", "visibility": "HIDDEN", "weight": 0.10, "order": 5},
        {"name": "vectors 1-10 (stress)", "visibility": "HIDDEN", "weight": 0.10, "order": 6},
        {"name": "vectors 1-10 (final-a)", "visibility": "HIDDEN", "weight": 0.10, "order": 7},
        {"name": "vectors 1-10 (final-b)", "visibility": "HIDDEN", "weight": 0.10, "order": 8},
        {"name": "vectors 1-10 (final-c)", "visibility": "HIDDEN", "weight": 0.10, "order": 9},
        {"name": "vectors 1-10 (final-d)", "visibility": "HIDDEN", "weight": 0.10, "order": 10},
    ],
    "half-adder": [
        {"name": "vectors 1-3 (basic)", "visibility": "PUBLIC", "weight": 0.10, "order": 1},
        {"name": "vectors 1-3 (verify)", "visibility": "PUBLIC", "weight": 0.10, "order": 2},
        {"name": "vectors 1-10 (full)", "visibility": "HIDDEN", "weight": 0.10, "order": 3},
        {"name": "vectors 1-10 (repeat)", "visibility": "HIDDEN", "weight": 0.10, "order": 4},
        {"name": "vectors 1-10 (edge)", "visibility": "HIDDEN", "weight": 0.10, "order": 5},
        {"name": "vectors 1-10 (stress)", "visibility": "HIDDEN", "weight": 0.10, "order": 6},
        {"name": "vectors 1-10 (final-a)", "visibility": "HIDDEN", "weight": 0.10, "order": 7},
        {"name": "vectors 1-10 (final-b)", "visibility": "HIDDEN", "weight": 0.10, "order": 8},
        {"name": "vectors 1-10 (final-c)", "visibility": "HIDDEN", "weight": 0.10, "order": 9},
        {"name": "vectors 1-10 (final-d)", "visibility": "HIDDEN", "weight": 0.10, "order": 10},
    ],
    "full-adder": [
        {"name": "vectors 1-3 (basic)", "visibility": "PUBLIC", "weight": 0.10, "order": 1},
        {"name": "vectors 1-3 (verify)", "visibility": "PUBLIC", "weight": 0.10, "order": 2},
        {"name": "vectors 1-10 (full)", "visibility": "HIDDEN", "weight": 0.10, "order": 3},
        {"name": "vectors 1-10 (repeat)", "visibility": "HIDDEN", "weight": 0.10, "order": 4},
        {"name": "vectors 1-10 (edge)", "visibility": "HIDDEN", "weight": 0.10, "order": 5},
        {"name": "vectors 1-10 (stress)", "visibility": "HIDDEN", "weight": 0.10, "order": 6},
        {"name": "vectors 1-10 (final-a)", "visibility": "HIDDEN", "weight": 0.10, "order": 7},
        {"name": "vectors 1-10 (final-b)", "visibility": "HIDDEN", "weight": 0.10, "order": 8},
        {"name": "vectors 1-10 (final-c)", "visibility": "HIDDEN", "weight": 0.10, "order": 9},
        {"name": "vectors 1-10 (final-d)", "visibility": "HIDDEN", "weight": 0.10, "order": 10},
    ],
    "d-flip-flop": [
        {"name": "vectors 1-3 (basic)", "visibility": "PUBLIC", "weight": 0.10, "order": 1},
        {"name": "vectors 1-3 (verify)", "visibility": "PUBLIC", "weight": 0.10, "order": 2},
        {"name": "vectors 1-10 (full)", "visibility": "HIDDEN", "weight": 0.10, "order": 3},
        {"name": "vectors 1-10 (repeat)", "visibility": "HIDDEN", "weight": 0.10, "order": 4},
        {"name": "vectors 1-10 (edge)", "visibility": "HIDDEN", "weight": 0.10, "order": 5},
        {"name": "vectors 1-10 (stress)", "visibility": "HIDDEN", "weight": 0.10, "order": 6},
        {"name": "vectors 1-10 (final-a)", "visibility": "HIDDEN", "weight": 0.10, "order": 7},
        {"name": "vectors 1-10 (final-b)", "visibility": "HIDDEN", "weight": 0.10, "order": 8},
        {"name": "vectors 1-10 (final-c)", "visibility": "HIDDEN", "weight": 0.10, "order": 9},
        {"name": "vectors 1-10 (final-d)", "visibility": "HIDDEN", "weight": 0.10, "order": 10},
    ],
    "4-bit-counter": [
        {"name": "vectors 1-3 (basic)", "visibility": "PUBLIC", "weight": 0.10, "order": 1},
        {"name": "vectors 1-3 (verify)", "visibility": "PUBLIC", "weight": 0.10, "order": 2},
        {"name": "vectors 1-10 (full)", "visibility": "HIDDEN", "weight": 0.10, "order": 3},
        {"name": "vectors 1-10 (repeat)", "visibility": "HIDDEN", "weight": 0.10, "order": 4},
        {"name": "vectors 1-10 (edge)", "visibility": "HIDDEN", "weight": 0.10, "order": 5},
        {"name": "vectors 1-10 (stress)", "visibility": "HIDDEN", "weight": 0.10, "order": 6},
        {"name": "vectors 1-10 (final-a)", "visibility": "HIDDEN", "weight": 0.10, "order": 7},
        {"name": "vectors 1-10 (final-b)", "visibility": "HIDDEN", "weight": 0.10, "order": 8},
        {"name": "vectors 1-10 (final-c)", "visibility": "HIDDEN", "weight": 0.10, "order": 9},
        {"name": "vectors 1-10 (final-d)", "visibility": "HIDDEN", "weight": 0.10, "order": 10},
    ],
    "4-bit-alu": [
        {"name": "vectors 1-3 (basic)", "visibility": "PUBLIC", "weight": 0.10, "order": 1},
        {"name": "vectors 1-3 (verify)", "visibility": "PUBLIC", "weight": 0.10, "order": 2},
        {"name": "vectors 1-10 (full)", "visibility": "HIDDEN", "weight": 0.10, "order": 3},
        {"name": "vectors 1-10 (repeat)", "visibility": "HIDDEN", "weight": 0.10, "order": 4},
        {"name": "vectors 1-10 (edge)", "visibility": "HIDDEN", "weight": 0.10, "order": 5},
        {"name": "vectors 1-10 (stress)", "visibility": "HIDDEN", "weight": 0.10, "order": 6},
        {"name": "vectors 1-10 (final-a)", "visibility": "HIDDEN", "weight": 0.10, "order": 7},
        {"name": "vectors 1-10 (final-b)", "visibility": "HIDDEN", "weight": 0.10, "order": 8},
        {"name": "vectors 1-10 (final-c)", "visibility": "HIDDEN", "weight": 0.10, "order": 9},
        {"name": "vectors 1-10 (final-d)", "visibility": "HIDDEN", "weight": 0.10, "order": 10},
    ],
}


def seed_problems() -> None:
    """Seed problems and test cases. Idempotent — skips if data exists."""
    db = SessionLocal()
    try:
        existing = db.query(Problem).count()
        if existing > 0:
            logger.info("Database has %d problems. Updating test cases and metadata.", existing)
            for problem_data in SEED_PROBLEMS:
                slug = problem_data["slug"]
                existing_problem = db.query(Problem).filter(Problem.slug == slug).first()
                if existing_problem:
                    for field in ["time_complexity", "space_complexity", "reference_solution"]:
                        if field in problem_data:
                            setattr(existing_problem, field, problem_data[field])
                    _seed_test_cases(db, existing_problem, slug)
            db.commit()
            logger.info("Test cases and metadata updated.")
            return

        for problem_data in SEED_PROBLEMS:
            slug = problem_data["slug"]
            problem = Problem(**problem_data)
            db.add(problem)
            db.flush()
            _seed_test_cases(db, problem, slug)

        db.commit()
        total_tests = db.query(TestCase).count()
        logger.info("Seeded %d problems with %d test cases.", len(SEED_PROBLEMS), total_tests)
    except Exception as e:
        db.rollback()
        logger.error("Error seeding: %s", e)
        raise
    finally:
        db.close()


def _seed_test_cases(db: Session, problem: Problem, slug: str) -> None:
    """Replace test case rows for a problem with Phase 9B comprehensive tests."""
    existing_count = db.query(TestCase).filter(TestCase.problem_id == problem.id).count()
    if existing_count > 0:
        logger.info("Deleting %d old test cases for %s.", existing_count, slug)
        db.query(TestCase).filter(TestCase.problem_id == problem.id).delete()

    configs = TEST_CASES_CONFIG.get(slug, [])
    public_tb = PUBLIC_TESTBENCHES.get(slug, "")
    hidden_tb = HIDDEN_TESTBENCHES.get(slug, "")

    for cfg in configs:
        visibility = TestVisibility.PUBLIC if cfg["visibility"] == "PUBLIC" else TestVisibility.HIDDEN
        tb = public_tb if cfg["visibility"] == "PUBLIC" else hidden_tb

        tc = TestCase(
            problem_id=problem.id,
            name=cfg["name"],
            description="Phase 9B comprehensive test",
            testbench=tb,
            visibility=visibility,
            weight=cfg["weight"],
            execution_order=cfg["order"],
            enabled=True,
        )
        db.add(tc)

    logger.info("Created %d test cases for %s", len(configs), slug)
