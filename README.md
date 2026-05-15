# Autonomous Threat Detection and Response System

## Introduction
In this project a Zybo-Z7 board paired with a US-100 Ultrasonic Sensor was used to create an autonomous threat detection and response system. The system was designed to measure the distance of an object in front of it, measure its velocity and determine a response using LED outputs. The code for the Processing System (PS) was written in C using Vitis. A custom AXI-Lite IP was used to implement the threat classification logic in the Programable Logic (PL). The main goal of this project was to show an embedded system that combines sensing, computation and hardware acceleration. This system performs filtering, velocity estimation, and decision making to classify threats and respond automatically.

---

## System Architecture

- **Processing System (PS):** Reads sensor data and computes velocity  
- **AXI Interface:** Transfers data between PS and FPGA  
- **Programmable Logic (PL):** Performs threat classification and controls LEDs  

---
<img width="1048" height="761" alt="image" src="https://github.com/user-attachments/assets/f1461038-c3d1-4883-a386-bfee8b179141" />

---

## Components Used
-	Zybo Z7-10 (Zynq-7000 SoC Development Board) 
-	Ultrasonic Sensor (US-100) 
-	Breadboard and jumper wires 
-	PMOD interface for GPIO connections 
-	USB connection for programming and UART output

---

## LED Threat Levels
-	LED0 →LOW
-	LED1 → MED
-	LED3 → HIGH

---

## Background and Methodology
Autonomous embedded systems require the combination of sensing, real-time processing and hardware decision logic. A perfect environment for this is provided by the Zynq SoC platform since this system joins an ARM processor (PS) with FPGA logic. This project was developed in several stages. The first stage focused on the LEDs on the board and verifying the FPGA output. This ensured that the pin mapping and hardware functionality was proper before integrating more complex components. The second involved creating a custom AXI-Lite IP core to allow communication between the PS and PL. This connected the software and the hardware in real-time. The third stage deals with implementing the ultrasonic sensor using EMIO GPIO. The Processing System generated trigger pulses and measured the echo signal to calculate distance. At first, the raw sensor readings were very inconsistent due to noise and occasional incorrect values. To correct this, I implemented a median filter to remove outliers and a moving average filter to smooth the signal over time. These filters significantly improved the stability of the measurement. The final stage involved implementing the threat detection logic and latch mechanism. Distance and velocity were both used to classify threats, and a latch mechanism was used to prevent unstable switches. When an object entered a certain range, it would force a high threat response and stay there until it was out of range. After integrating all components, the system was tested using real objects to validate performance and reliability.

---

## Pinouts Used
-	TRIG → JC1(Output) 
-	ECHO → JC2 (Input) 
-	LED Outputs → FPGA pins mapped through XDC constraints


## Hardware Design
The hardware system was implemented in Vivado using a block diagram consisting of:
- Zynq Processing System  
- Custom AXI-Lite IP  
- EMIO GPIO interface  

The ultrasonic sensor connects through:
- **TRIG (output from PS)**  
- **ECHO (input to PS)**  


---

## Software Design
The software was developed in Vitis using C. The program:
- Controls the ultrasonic sensor  
- Computes distance from echo timing  
- Estimates velocity from consecutive measurements  
- Sends processed data to the FPGA via AXI  

## Block Diagram:

<img width="1315" height="473" alt="image" src="https://github.com/user-attachments/assets/2d903caf-c3a5-43f5-8239-ebb586d02a80" />


---

## Conclusion
In conclusion, the project successfully implemented an autonomous threat detection and response system using the Zynq SoC platform. By implementing ultrasonic sensing, signal processing, and FPGA-based decision logic, the system was able to detect and respond to objects in the environment in real time. The project demonstrates key concepts such as hardware/software co-design, real-time processing, and signal filtering. The filters and latch mechanism implementation highlighted their impact on stable and reliable data reading. Overall, this project provided valuable experience in sensor implementation, signal filtering, and hardware/software co-design.

---


## Demo
https://www.youtube.com/shorts/6LTKwwXDzWw?feature=share

https://www.youtube.com/shorts/aDIs1nUZo6w?feature=share

---

## Author
Jovany Caballero 
ECE 520 
