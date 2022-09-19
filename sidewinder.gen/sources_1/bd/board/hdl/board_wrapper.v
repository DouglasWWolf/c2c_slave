//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
//Date        : Mon Sep 19 15:16:07 2022
//Host        : simtool5-2 running 64-bit Ubuntu 20.04.5 LTS
//Command     : generate_target board_wrapper.bd
//Design      : board_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module board_wrapper
   (GPIO_LED_tri_o,
    c2c_link_status,
    channel_up_0,
    channel_up_1,
    clk_100mhz_clk_n,
    clk_100mhz_clk_p,
    led_heartbeat,
    pb_rst_n,
    qsfp0_clk_clk_n,
    qsfp0_clk_clk_p,
    qsfp0_rx_rxn,
    qsfp0_rx_rxp,
    qsfp0_tx_txn,
    qsfp0_tx_txp,
    qsfp1_clk_clk_n,
    qsfp1_clk_clk_p,
    qsfp1_rx_rxn,
    qsfp1_rx_rxp,
    qsfp1_tx_txn,
    qsfp1_tx_txp,
    sys_reset_out_0,
    sys_reset_out_1);
  output [3:0]GPIO_LED_tri_o;
  output c2c_link_status;
  output channel_up_0;
  output channel_up_1;
  input [0:0]clk_100mhz_clk_n;
  input [0:0]clk_100mhz_clk_p;
  output led_heartbeat;
  input pb_rst_n;
  input qsfp0_clk_clk_n;
  input qsfp0_clk_clk_p;
  input [0:3]qsfp0_rx_rxn;
  input [0:3]qsfp0_rx_rxp;
  output [0:3]qsfp0_tx_txn;
  output [0:3]qsfp0_tx_txp;
  input qsfp1_clk_clk_n;
  input qsfp1_clk_clk_p;
  input [0:0]qsfp1_rx_rxn;
  input [0:0]qsfp1_rx_rxp;
  output [0:0]qsfp1_tx_txn;
  output [0:0]qsfp1_tx_txp;
  output sys_reset_out_0;
  output sys_reset_out_1;

  wire [3:0]GPIO_LED_tri_o;
  wire c2c_link_status;
  wire channel_up_0;
  wire channel_up_1;
  wire [0:0]clk_100mhz_clk_n;
  wire [0:0]clk_100mhz_clk_p;
  wire led_heartbeat;
  wire pb_rst_n;
  wire qsfp0_clk_clk_n;
  wire qsfp0_clk_clk_p;
  wire [0:3]qsfp0_rx_rxn;
  wire [0:3]qsfp0_rx_rxp;
  wire [0:3]qsfp0_tx_txn;
  wire [0:3]qsfp0_tx_txp;
  wire qsfp1_clk_clk_n;
  wire qsfp1_clk_clk_p;
  wire [0:0]qsfp1_rx_rxn;
  wire [0:0]qsfp1_rx_rxp;
  wire [0:0]qsfp1_tx_txn;
  wire [0:0]qsfp1_tx_txp;
  wire sys_reset_out_0;
  wire sys_reset_out_1;

  board board_i
       (.GPIO_LED_tri_o(GPIO_LED_tri_o),
        .c2c_link_status(c2c_link_status),
        .channel_up_0(channel_up_0),
        .channel_up_1(channel_up_1),
        .clk_100mhz_clk_n(clk_100mhz_clk_n),
        .clk_100mhz_clk_p(clk_100mhz_clk_p),
        .led_heartbeat(led_heartbeat),
        .pb_rst_n(pb_rst_n),
        .qsfp0_clk_clk_n(qsfp0_clk_clk_n),
        .qsfp0_clk_clk_p(qsfp0_clk_clk_p),
        .qsfp0_rx_rxn(qsfp0_rx_rxn),
        .qsfp0_rx_rxp(qsfp0_rx_rxp),
        .qsfp0_tx_txn(qsfp0_tx_txn),
        .qsfp0_tx_txp(qsfp0_tx_txp),
        .qsfp1_clk_clk_n(qsfp1_clk_clk_n),
        .qsfp1_clk_clk_p(qsfp1_clk_clk_p),
        .qsfp1_rx_rxn(qsfp1_rx_rxn),
        .qsfp1_rx_rxp(qsfp1_rx_rxp),
        .qsfp1_tx_txn(qsfp1_tx_txn),
        .qsfp1_tx_txp(qsfp1_tx_txp),
        .sys_reset_out_0(sys_reset_out_0),
        .sys_reset_out_1(sys_reset_out_1));
endmodule
