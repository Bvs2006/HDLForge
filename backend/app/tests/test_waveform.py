"""Tests for VCD parser and waveform functionality."""

import pytest

from app.simulator.vcd_parser import VCDParser, VCDParseError, WaveformData


SAMPLE_VCD = """\
$timescale 1ns $end
$scope module testbench $end
$var wire 1 a clk $end
$var wire 1 b rst $end
$var wire 4 c count $end
$enddefinitions $end
#0
0a
1b
b0000c
#5
1a
#10
0a
b0001c
#15
1a
b0010c
#20
0a
b0011c
"""

SINGLE_BIT_VCD = """\
$timescale 10ps $end
$scope module tb $end
$var wire 1 x in $end
$var wire 1 y out $end
$enddefinitions $end
#0
0x
0y
#100
1x
1y
#200
0x
0y
"""

MULTI_BIT_VCD = """\
$timescale 1ns $end
$scope module tb $end
$var wire 8 d data $end
$enddefinitions $end
#0
b00000000d
#10
b10101010d
#20
b11111111d
"""

X_Z_VALUES_VCD = """\
$timescale 1ns $end
$scope module tb $end
$var wire 4 d data $end
$enddefinitions $end
#0
bxxxxd
#10
bzzzzd
#20
b1010d
"""

EMPTY_VCD = ""

NO_SIGNALS_VCD = """\
$timescale 1ns $end
$scope module tb $end
$enddefinitions $end
#0
#10
#20
"""


class TestVCDParser:
    def setup_method(self):
        self.parser = VCDParser()

    def test_parse_basic_vcd(self):
        result = self.parser.parse(SAMPLE_VCD)
        assert isinstance(result, WaveformData)
        assert result.timescale == "1ns"
        assert len(result.signals) == 3
        assert result.duration == 20

    def test_parse_timescale(self):
        result = self.parser.parse(SINGLE_BIT_VCD)
        assert result.timescale == "10ps"
        assert result.timescale_multiplier == 10
        assert result.timescale_unit == "ps"

    def test_parse_single_bit_signals(self):
        result = self.parser.parse(SINGLE_BIT_VCD)
        assert len(result.signals) == 2

        in_signal = next(s for s in result.signals if s.name == "tb.in")
        assert in_signal.width == 1
        assert len(in_signal.changes) == 3
        assert in_signal.changes[0].time == 0
        assert in_signal.changes[0].value == "0"
        assert in_signal.changes[1].time == 100
        assert in_signal.changes[1].value == "1"

    def test_parse_multi_bit_signals(self):
        result = self.parser.parse(MULTI_BIT_VCD)
        assert len(result.signals) == 1

        data_signal = result.signals[0]
        assert data_signal.name == "tb.data"
        assert data_signal.width == 8
        assert len(data_signal.changes) == 3
        assert data_signal.changes[0].value == "00000000"
        assert data_signal.changes[1].value == "10101010"
        assert data_signal.changes[2].value == "11111111"

    def test_parse_x_z_values(self):
        result = self.parser.parse(X_Z_VALUES_VCD)
        assert len(result.signals) == 1

        data_signal = result.signals[0]
        assert data_signal.width == 4
        assert len(data_signal.changes) == 3
        assert data_signal.changes[0].value == "xxxx"
        assert data_signal.changes[1].value == "zzzz"
        assert data_signal.changes[2].value == "1010"

    def test_parse_empty_vcd(self):
        with pytest.raises(VCDParseError, match="Empty VCD content"):
            self.parser.parse(EMPTY_VCD)

    def test_parse_no_signals(self):
        result = self.parser.parse(NO_SIGNALS_VCD)
        assert len(result.signals) == 0
        assert result.duration == 0

    def test_parse_malformed_vcd(self):
        malformed = "This is not a VCD file"
        result = self.parser.parse(malformed)
        assert len(result.signals) == 0

    def test_max_signals_limit(self):
        result = self.parser.parse(SAMPLE_VCD, max_signals=2)
        assert len(result.signals) <= 2

    def test_signal_hierarchy(self):
        vcd = """\
$timescale 1ns $end
$scope module tb $end
$scope module uut $end
$var wire 1 a clk $end
$upscope $end
$enddefinitions $end
"""
        result = self.parser.parse(vcd)
        assert len(result.signals) == 1
        assert result.signals[0].name == "tb.uut.clk"


class TestWaveformModel:
    def test_waveform_data_defaults(self):
        wf = WaveformData()
        assert wf.timescale == "1ns"
        assert wf.duration == 0
        assert wf.signals == []

    def test_signal_change(self):
        from app.simulator.vcd_parser import SignalChange
        change = SignalChange(time=10, value="1")
        assert change.time == 10
        assert change.value == "1"


class TestVCDParserEdgeCases:
    def setup_method(self):
        self.parser = VCDParser()

    def test_vcd_with_comments(self):
        vcd = """\
$timescale 1ns $end
// This is a comment
$scope module tb $end
$var wire 1 a clk $end
$enddefinitions $end
#0
0a
#5
1a
"""
        result = self.parser.parse(vcd)
        assert len(result.signals) == 1
        assert result.duration == 5

    def test_vcd_with_dumpall(self):
        vcd = """\
$timescale 1ns $end
$scope module tb $end
$var wire 1 a clk $end
$enddefinitions $end
$dumpall
0a
$end
#5
1a
"""
        result = self.parser.parse(vcd)
        assert len(result.signals) == 1

    def test_value_change_parsing(self):
        vcd = """\
$timescale 1ns $end
$scope module tb $end
$var wire 1 a clk $end
$var wire 8 b data $end
$enddefinitions $end
#0
0a
b01010101b
#5
1a
b10101010b
"""
        result = self.parser.parse(vcd)
        assert len(result.signals) == 2

        data_signal = next(s for s in result.signals if s.name == "tb.data")
        assert data_signal.width == 8
        assert data_signal.changes[0].value == "01010101"
        assert data_signal.changes[1].value == "10101010"

    def test_scope_without_var(self):
        vcd = """\
$timescale 1ns $end
$scope module tb $end
$scope module uut $end
$enddefinitions $end
#0
#10
"""
        result = self.parser.parse(vcd)
        assert len(result.signals) == 0
