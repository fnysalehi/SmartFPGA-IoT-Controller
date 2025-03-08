# FPGA SmartCity Core Specifications

## System Overview
- Clock frequency: Standard FPGA frequencies
- Reset: Active low, asynchronous
- Interface: Serial command-based

## Smart Parking System
### Capacity
- Maximum spaces: 100
- Zones: A, B, C, D
- LED indicators: 6-bit output

### Command Format
- Input: `<location>*<plate_number>#`
- Location: 2-digit number (00-99)
- Plate number: 5-digit number
- Example: `25*12345#`

## Irrigation System
### Sensors
- Temperature: 8-bit input (-50°C to 100°C)
- Moisture: 7-bit input (0-100%)
- Time: 16-bit input (HH:MM format)

### Thresholds
- High temperature: 35°C
- Low temperature: 15°C
- Moisture threshold: 30%