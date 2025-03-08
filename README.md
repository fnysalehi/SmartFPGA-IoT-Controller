# FPGA Smart Parking and Irrigation System

A VHDL implementation of an intelligent parking management and automated irrigation system using FPGA.

## Features

### Smart Parking System
- Real-time parking space management
- Binary search-based vehicle lookup
- LED indicators for parking zone guidance
- Support for up to 100 parking spaces
- Serial input interface for commands

### Automated Irrigation System
- Temperature-based watering control
- Time-based scheduling (24-hour format)
- Moisture level monitoring
- Automatic emergency shutdown
- Configurable thresholds

## Module Description

### Main Components
- `main.vhd`: Top-level entity coordinating all subsystems
- `serialadd.vhd`: Serial command processor for parking management
- `search.vhd`: Binary search implementation for vehicle lookup
- `water_system.vhd`: Automated irrigation control system

## Usage

### Parking System Commands
- Format: `<location>*<plate_number>#`
- Location: 2-digit number (00-99)
- Plate number: 5-digit number
- Example: `25*12345#` (assigns plate 12345 to location 25)

### Irrigation System Controls
- Temperature input: 8-bit vector
- Time input: 16-bit vector (HH:MM format)
- Moisture data: 7-bit vector
- Command input: 32-bit control vector

## Implementation Details

### Timing Requirements
- System clock: Compatible with standard FPGA frequencies
- All modules are synchronous with positive clock edge triggering
- Asynchronous reset (active low) for safe initialization
