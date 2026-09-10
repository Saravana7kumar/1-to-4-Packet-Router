# Router (1-to-4 Packet Router)

A single-input, 4-output packet router written in Verilog, routing incoming packets to one of four output ports based on a 2-bit destination field, using a `valid`/`ready` handshake per port.

## Files

```
router.v       # RTL
router_tb.v    # testbench
```

## Design

- Packet format: `in_data[9:8]` = destination port (0–3), `in_data[7:0]` = payload.
- Purely combinational routing — no internal buffering.
- `in_ready` reflects the `ready` signal of whichever output port is currently targeted, so backpressure on one port only stalls the input when that port is the active destination.

## Ports

| Signal      | Dir | Width | Description                  |
|-------------|-----|-------|--------------------------------|
| clk         | in  | 1     | clock                        |
| rst_n       | in  | 1     | active-low async reset       |
| in_valid    | in  | 1     | input packet valid           |
| in_data     | in  | 10    | `{dest[1:0], data[7:0]}`     |
| in_ready    | out | 1     | input ready (depends on selected port) |
| out0_valid  | out | 1     | output valid, port 0         |
| out0_data   | out | 8     | output data, port 0          |
| out0_ready  | in  | 1     | downstream ready, port 0     |
| out1_valid  | out | 1     | output valid, port 1         |
| out1_data   | out | 8     | output data, port 1          |
| out1_ready  | in  | 1     | downstream ready, port 1     |
| out2_valid  | out | 1     | output valid, port 2         |
| out2_data   | out | 8     | output data, port 2          |
| out2_ready  | in  | 1     | downstream ready, port 2     |
| out3_valid  | out | 1     | output valid, port 3         |
| out3_data   | out | 8     | output data, port 3          |
| out3_ready  | in  | 1     | downstream ready, port 3     |

## Testbench

Sends packets to each of the four ports in turn using a `send_pkt` task, then specifically tests backpressure by holding `out2_ready` low while targeting port 2 — confirming `in_ready` drops until the port is released. All output activity is printed via `$display`.

## Running the simulation

```bash
iverilog -o sim_router router.v router_tb.v
vvp sim_router
```

## Notes / possible extensions

Single-input, single-cycle, combinational design. A natural next step would be adding input buffering and round-robin arbitration to turn this into a multi-input crossbar/NoC-style router.
