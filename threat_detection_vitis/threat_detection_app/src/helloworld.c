#include <stdio.h>
#include "platform.h"
#include "xgpiops.h"
#include "xil_io.h"
#include "sleep.h"

// AXI base address
#define BASE_ADDR 0x43C00000

// EMIO GPIO pins
#define TRIG_PIN 54
#define ECHO_PIN 55

#define AVG_WINDOW 5

XGpioPs Gpio;

// Median Filter
int median3(int a, int b, int c)
{
    if ((a <= b && b <= c) || (c <= b && b <= a)) return b;
    if ((b <= a && a <= c) || (c <= a && a <= b)) return a;
    return c;
}

// Moving Average
int moving_average(int new_sample)
{
    static int buf[AVG_WINDOW] = {0};
    static int idx = 0;
    static int count = 0;

    buf[idx] = new_sample;
    idx = (idx + 1) % AVG_WINDOW;

    if (count < AVG_WINDOW) count++;

    int sum = 0;
    for (int i = 0; i < count; i++)
        sum += buf[i];

    return sum / count;
}

// Measure Distance
int measure_distance_cm()
{
    // Trigger pulse
    XGpioPs_WritePin(&Gpio, TRIG_PIN, 0);
    usleep(5);

    XGpioPs_WritePin(&Gpio, TRIG_PIN, 1);
    usleep(10);
    XGpioPs_WritePin(&Gpio, TRIG_PIN, 0);

    int timeout = 0;

    // Wait for echo HIGH
    while (XGpioPs_ReadPin(&Gpio, ECHO_PIN) == 0)
    {
        usleep(1);
        if (++timeout > 30000)
            return -1;
    }

    int pulse_us = 0;

    // Measure pulse width
    while (XGpioPs_ReadPin(&Gpio, ECHO_PIN) == 1)
    {
        usleep(1);
        if (++pulse_us > 30000)
            return -1;
    }

    return pulse_us / 58;
}

// MAIN
int main()
{
    init_platform();

    // GPIO setup
    XGpioPs_Config *ConfigPtr;
    ConfigPtr = XGpioPs_LookupConfig(XPAR_XGPIOPS_0_DEVICE_ID);
    XGpioPs_CfgInitialize(&Gpio, ConfigPtr, ConfigPtr->BaseAddr);

    // TRIG = output
    XGpioPs_SetDirectionPin(&Gpio, TRIG_PIN, 1);
    XGpioPs_SetOutputEnablePin(&Gpio, TRIG_PIN, 1);

    // ECHO = input
    XGpioPs_SetDirectionPin(&Gpio, ECHO_PIN, 0);

    printf("=== Ultrasonic Threat Detection System ===\r\n");

    int prev_distance = 0;
    static int latch = 0;

    while (1)
    {
        // Take 3 samples
        int d1 = measure_distance_cm();
        usleep(2000);
        int d2 = measure_distance_cm();
        usleep(2000);
        int d3 = measure_distance_cm();

        int distance;

        if (d1 < 0 || d2 < 0 || d3 < 0)
        {
            printf("No echo detected\r\n");
            distance = 50;
        }
        else
        {
            int med = median3(d1, d2, d3);
            distance = moving_average(med);
        }

        printf("Distance: %d cm\r\n", distance);

        //  LATCH LOGIC
        if (distance <= 10)
        {
            latch = 1;
        }
        else if (distance > 20)
        {
            latch = 0;
        }

        if (latch)
        {
            printf("LATCHED HIGH\r\n");

            // Force HIGH threat
            Xil_Out32(BASE_ADDR + 0x00, 5);
            Xil_Out32(BASE_ADDR + 0x04, 10);
        }
        else
        {
            int velocity = prev_distance - distance;
            if (velocity < 0) velocity = 0;

            printf("Velocity: %d\r\n", velocity);

            Xil_Out32(BASE_ADDR + 0x00, distance);
            Xil_Out32(BASE_ADDR + 0x04, velocity);
        }

        prev_distance = distance;

        usleep(150000);
    }

    cleanup_platform();
    return 0;
}
