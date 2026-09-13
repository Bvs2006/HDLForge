import { Problem } from "./types";

export const problems: Problem[] = [
  {
    id: "1",
    slug: "and-gate",
    title: "AND Gate",
    difficulty: "easy",
    category: "combinational",
    language: "systemverilog",
    description:
      "Implement a 2-input AND gate. The output should be 1 only when both inputs are 1.",
    inputDescription: "a, b — single-bit inputs",
    outputDescription: "y — single-bit output",
    constraints: ["Both inputs are single-bit values"],
    examples: [
      {
        title: "Both inputs high",
        input: "a = 1, b = 1",
        output: "y = 1",
      },
      {
        title: "One input low",
        input: "a = 1, b = 0",
        output: "y = 0",
      },
    ],
    starterCode: `module and_gate (
  input  logic a,
  input  logic b,
  output logic y
);

  // Your code here

endmodule`,
  },
  {
    id: "2",
    slug: "or-gate",
    title: "OR Gate",
    difficulty: "easy",
    category: "combinational",
    language: "systemverilog",
    description:
      "Implement a 2-input OR gate. The output should be 1 when at least one input is 1.",
    inputDescription: "a, b — single-bit inputs",
    outputDescription: "y — single-bit output",
    constraints: ["Both inputs are single-bit values"],
    examples: [
      {
        title: "Both inputs low",
        input: "a = 0, b = 0",
        output: "y = 0",
      },
      {
        title: "One input high",
        input: "a = 0, b = 1",
        output: "y = 1",
      },
    ],
    starterCode: `module or_gate (
  input  logic a,
  input  logic b,
  output logic y
);

  // Your code here

endmodule`,
  },
  {
    id: "3",
    slug: "not-gate",
    title: "NOT Gate",
    difficulty: "easy",
    category: "combinational",
    language: "systemverilog",
    description:
      "Implement a NOT gate (inverter). The output should be the inverse of the input.",
    inputDescription: "a — single-bit input",
    outputDescription: "y — single-bit output",
    constraints: ["Input is a single-bit value"],
    examples: [
      {
        title: "Input high",
        input: "a = 1",
        output: "y = 0",
      },
      {
        title: "Input low",
        input: "a = 0",
        output: "y = 1",
      },
    ],
    starterCode: `module not_gate (
  input  logic a,
  output logic y
);

  // Your code here

endmodule`,
  },
  {
    id: "4",
    slug: "xor-gate",
    title: "XOR Gate",
    difficulty: "easy",
    category: "combinational",
    language: "systemverilog",
    description:
      "Implement a 2-input XOR gate. The output should be 1 when the inputs are different.",
    inputDescription: "a, b — single-bit inputs",
    outputDescription: "y — single-bit output",
    constraints: ["Both inputs are single-bit values"],
    examples: [
      {
        title: "Same inputs",
        input: "a = 0, b = 0",
        output: "y = 0",
      },
      {
        title: "Different inputs",
        input: "a = 0, b = 1",
        output: "y = 1",
      },
    ],
    starterCode: `module xor_gate (
  input  logic a,
  input  logic b,
  output logic y
);

  // Your code here

endmodule`,
  },
  {
    id: "5",
    slug: "multiplexer-2-1",
    title: "2:1 Multiplexer",
    difficulty: "easy",
    category: "combinational",
    language: "systemverilog",
    description:
      "Implement a 2-to-1 multiplexer. When sel is 0, output a; when sel is 1, output b.",
    inputDescription: "a, b — single-bit inputs, sel — select signal",
    outputDescription: "y — single-bit output",
    constraints: ["All inputs are single-bit values"],
    examples: [
      {
        title: "Select a",
        input: "a = 1, b = 0, sel = 0",
        output: "y = 1",
      },
      {
        title: "Select b",
        input: "a = 1, b = 0, sel = 1",
        output: "y = 0",
      },
    ],
    starterCode: `module mux2 (
  input  logic a,
  input  logic b,
  input  logic sel,
  output logic y
);

  // Your code here

endmodule`,
  },
  {
    id: "6",
    slug: "half-adder",
    title: "Half Adder",
    difficulty: "easy",
    category: "arithmetic",
    language: "systemverilog",
    description:
      "Implement a half adder that adds two single-bit inputs producing sum and carry outputs.",
    inputDescription: "a, b — single-bit inputs",
    outputDescription: "sum, carry — single-bit outputs",
    constraints: ["Both inputs are single-bit values"],
    examples: [
      {
        title: "0 + 0",
        input: "a = 0, b = 0",
        output: "sum = 0, carry = 0",
      },
      {
        title: "1 + 1",
        input: "a = 1, b = 1",
        output: "sum = 0, carry = 1",
      },
    ],
    starterCode: `module half_adder (
  input  logic a,
  input  logic b,
  output logic sum,
  output logic carry
);

  // Your code here

endmodule`,
  },
  {
    id: "7",
    slug: "full-adder",
    title: "Full Adder",
    difficulty: "easy",
    category: "arithmetic",
    language: "systemverilog",
    description:
      "Implement a full adder that adds two single-bit inputs plus a carry-in, producing sum and carry-out.",
    inputDescription: "a, b — single-bit inputs, cin — carry-in",
    outputDescription: "sum, cout — single-bit outputs",
    constraints: ["All inputs are single-bit values"],
    examples: [
      {
        title: "1 + 1 + 0",
        input: "a = 1, b = 1, cin = 0",
        output: "sum = 0, cout = 1",
      },
      {
        title: "1 + 1 + 1",
        input: "a = 1, b = 1, cin = 1",
        output: "sum = 1, cout = 1",
      },
    ],
    starterCode: `module full_adder (
  input  logic a,
  input  logic b,
  input  logic cin,
  output logic sum,
  output logic cout
);

  // Your code here

endmodule`,
  },
  {
    id: "8",
    slug: "d-flip-flop",
    title: "D Flip-Flop",
    difficulty: "easy",
    category: "sequential",
    language: "systemverilog",
    description:
      "Implement a positive-edge-triggered D flip-flop. On the rising edge of clk, the output q captures the input d.",
    inputDescription: "clk — clock signal, d — data input, rst — synchronous reset",
    outputDescription: "q — registered output",
    constraints: ["Reset is active high and synchronous"],
    examples: [
      {
        title: "Reset",
        input: "rst = 1",
        output: "q = 0",
      },
      {
        title: "Capture",
        input: "rst = 0, d = 1 (posedge clk)",
        output: "q = 1",
      },
    ],
    starterCode: `module d_flip_flop (
  input  logic clk,
  input  logic rst,
  input  logic d,
  output logic q
);

  // Your code here

endmodule`,
  },
  {
    id: "9",
    slug: "counter-4bit",
    title: "4-bit Counter",
    difficulty: "medium",
    category: "sequential",
    language: "systemverilog",
    description:
      "Design a synchronous 4-bit counter. The counter should reset to 0 when rst is asserted, increment on every rising edge of clk, and wrap from 15 back to 0.",
    inputDescription: "clk — clock signal, rst — synchronous active-high reset",
    outputDescription: "count[3:0] — 4-bit counter output",
    constraints: [
      "Reset is synchronous and active high",
      "Counter wraps from 15 to 0",
    ],
    examples: [
      {
        title: "Reset",
        input: "rst = 1",
        output: "count = 4'b0000",
      },
      {
        title: "Counting",
        input: "rst = 0, 4 clock edges",
        output: "count = 4'b0100",
      },
      {
        title: "Overflow",
        input: "count = 4'b1111, 1 clock edge",
        output: "count = 4'b0000",
      },
    ],
    starterCode: `module counter (
  input  logic        clk,
  input  logic        rst,
  output logic [3:0]  count
);

  always_ff @(posedge clk) begin
    if (rst)
      count <= 4'b0000;
    else
      count <= count + 1'b1;
  end

endmodule`,
  },
  {
    id: "10",
    slug: "alu-4bit",
    title: "ALU",
    difficulty: "medium",
    category: "arithmetic",
    language: "systemverilog",
    description:
      "Design a simple 4-bit arithmetic logic unit. The ALU should support addition, subtraction, AND, and OR operations based on a 2-bit opcode.",
    inputDescription:
      "a[3:0], b[3:0] — operands, op[1:0] — opcode (00=ADD, 01=SUB, 10=AND, 11=OR)",
    outputDescription: "result[3:0] — operation result",
    constraints: ["All operands are 4-bit values"],
    examples: [
      {
        title: "Addition",
        input: "a = 4'b0011, b = 4'b0001, op = 2'b00",
        output: "result = 4'b0100",
      },
      {
        title: "Subtraction",
        input: "a = 4'b0101, b = 4'b0010, op = 2'b01",
        output: "result = 4'b0011",
      },
    ],
    starterCode: `module alu (
  input  logic [3:0] a,
  input  logic [3:0] b,
  input  logic [1:0] op,
  output logic [3:0] result
);

  // Your code here

endmodule`,
  },
  {
    id: "11",
    slug: "async-fifo",
    title: "Asynchronous FIFO",
    difficulty: "hard",
    category: "memory",
    language: "systemverilog",
    description:
      "Design an asynchronous FIFO with separate read and write clock domains using Gray code pointers for safe clock domain crossing.",
    inputDescription:
      "wclk, rclk — write and read clocks, wrst_n, rrst_n — active-low resets, wdata — write data, wren — write enable, rden — read enable",
    outputDescription: "rdata — read data, full, empty — status flags",
    constraints: [
      "Must handle asynchronous clock domains",
      "Gray code pointer synchronization required",
    ],
    examples: [
      {
        title: "Write and read",
        input: "Write 0x5 to FIFO, then read",
        output: "rdata = 0x5, empty = 1 after read",
      },
    ],
    starterCode: `// Future problem - not yet available
module async_fifo #(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4
) (
  // This problem is not yet available
endmodule`,
    locked: true,
  },
  {
    id: "12",
    slug: "cache-controller",
    title: "Cache Controller",
    difficulty: "hard",
    category: "protocols",
    language: "systemverilog",
    description:
      "Design a simple direct-mapped cache controller with write-back policy and LRU replacement for a basic memory hierarchy.",
    inputDescription:
      "clk, rst — clock and reset, addr — memory address, wdata — write data, mem_read, mem_write — control signals",
    outputDescription:
      "rdata — read data, hit, miss — status signals",
    constraints: [
      "Direct-mapped cache",
      "Write-back with write-allocate",
      "4-byte cache lines",
    ],
    examples: [
      {
        title: "Cache miss on first access",
        input: "addr = 0x0000, mem_read = 1",
        output: "miss = 1, then data returned on next cycle",
      },
    ],
    starterCode: `// Future problem - not yet available
module cache_controller (
  // This problem is not yet available
endmodule`,
    locked: true,
  },
  {
    id: "13",
    slug: "axi-arbiter",
    title: "AXI Arbiter",
    difficulty: "hard",
    category: "protocols",
    language: "systemverilog",
    description:
      "Design an AXI4 bus arbiter that arbitrates between multiple master interfaces and routes transactions to a single slave port.",
    inputDescription: "Multiple AXI master interfaces",
    outputDescription: "Single AXI slave interface, arbitration signals",
    constraints: [
      "AXI4 specification compliance",
      "Support at least 4 masters",
      "Round-robin or priority-based arbitration",
    ],
    examples: [
      {
        title: "Single request",
        input: "Master 0 issues read request",
        output: "Master 0 granted, transaction forwarded to slave",
      },
    ],
    starterCode: `// Future problem - not yet available
module axi_arbiter (
  // This problem is not yet available
endmodule`,
    locked: true,
  },
];

export function getProblemBySlug(slug: string): Problem | undefined {
  return problems.find((p) => p.slug === slug);
}

export function getProblemsByDifficulty(
  difficulty: string
): Problem[] {
  return problems.filter((p) => p.difficulty === difficulty);
}

export function getProblemsByCategory(
  category: string
): Problem[] {
  return problems.filter((p) => p.category === category);
}
