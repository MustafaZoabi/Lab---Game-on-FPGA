# 🎮 FPGA Game on DE10-Standard (Intel FPGA) using SystemVerilog

This repository contains the source code and project files for a custom game implemented on the **DE10-Standard FPGA development board** by Intel. The game logic and hardware design are written in **SystemVerilog**, and the project was developed and compiled using **Intel Quartus Prime**.

## 🧠 Project Overview

This game is a hardware-level implementation that runs entirely on the FPGA, leveraging:

- Real-time input via on-board buttons/switches
- VGA output for video display
- Seven-segment displays and LEDs for game feedback
- Custom finite state machines and datapath components
- No software processor — purely RTL design

## 🛠️ Development Tools

- **FPGA Board:** Terasic DE10-Standard (Cyclone V SoC)
- **Language:** SystemVerilog
- **IDE:** Intel Quartus Prime Lite Edition
- **Simulation:** ModelSim (optional, for functional testing)

## 🎮 Game Features

> _You can update this section with the actual features of your game._

- Real-time interaction using push buttons and switches
- VGA output for displaying game graphics
- Score tracking via 7-segment display
- Reset and pause functionality
- Win/Loss condition handling

How To Run The files---------
Open in Quartus
Launch Intel Quartus Prime
Open the .qpf project file located in quartus_project/
Compile the project (Full Compilation)
Program the FPGA
Connect your DE10-Standard board via USB Blaster

Use Quartus Programmer to load the .sof file located in output_files/ onto the board

▶️ How to Play the Game
To play the game:

Simply run the .sof file on the board — no need to interact with any other files.

The game starts automatically after programming. Control it using the onboard switches and keyboard.
