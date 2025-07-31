# Asynchronous FIFO

## Overview

This project implements an **Asynchronous FIFO** designed to transfer data between independent clock domains using robust Clock Domain Crossing (CDC) techniques. The FIFO supports individual **read/write clocks**, **independent resets**, and **enable controls**, with reliable Gray code pointer synchronization.

> **Note**: This is a learning project implemented based on concepts and techniques outlined in the *Sunburst Design* paper:
> **Cliff Cummings – Simulation and Synthesis Techniques for Asynchronous FIFO Design** [(PDF)](https://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf)

## Key Features

* Dual clock support: separate clocks for read and write domains.
* Independent reset and enable control for each domain.
* Parameterized design: both **FIFO depth** (via address width) and **data width** are configurable.
* Gray code-based pointer synchronization for metastability-safe CDC.
* Full and empty status flag generation.
* Robust handling of simultaneous operations and asynchronous behavior.
* Designed for synthesis and simulation, adhering to best practices for CDC reliability.

## Microarchitecture

* Write and read pointers are maintained in binary and converted to Gray code for cross-domain synchronization.
* Gray code pointers are synchronized using double flip-flop synchronizers.
* Full and empty detection logic compares local and synchronized pointers.
* Asynchronous resets are managed independently in each domain to ensure safe recovery and state consistency.

## Verification

The FIFO was verified using a comprehensive set of testcases to ensure correctness, robustness, and CDC integrity under various scenarios. The testbench includes:

* Write and read operations; read without write.
* Multiple writes and reads.
* Full FIFO test: write until the FIFO is full.
* Empty FIFO test: read until the FIFO is empty.
* Simultaneous write and read.
* Boundary write/read: write until almost full and read until almost empty.
* Write after reset and read after reset (reset applied independently in both domains).
* Full and empty flags verification.
* Overfill condition handling: writing beyond full capacity.
* Underflow condition handling: reading beyond empty.
* Randomized write/read sequences.
* Cross-clock domain test with FIFO depth = 2 to stress CDC synchronization.
* Asynchronous reset verification: abrupt reset applied during operation, followed by integrity check through reads.
