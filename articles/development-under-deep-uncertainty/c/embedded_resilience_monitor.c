/*
 * embedded_resilience_monitor.c
 *
 * A simple embedded C example for infrastructure monitoring under deep uncertainty.
 * This program simulates threshold-based monitoring logic for environmental stress.
 *
 * Intended use case:
 * - water or drainage pump controller
 * - low-power environmental resilience monitor
 * - edge device that triggers alerts when uncertain conditions become unsafe
 */

#include <stdio.h>
#include <stdbool.h>

#define WATER_LEVEL_THRESHOLD 75.0
#define TEMPERATURE_THRESHOLD 42.0
#define BATTERY_MIN_THRESHOLD 20.0

typedef struct {
    float water_level_cm;
    float temperature_c;
    float battery_percent;
} SensorReadings;

bool is_water_risk(float water_level_cm) {
    return water_level_cm >= WATER_LEVEL_THRESHOLD;
}

bool is_temperature_risk(float temperature_c) {
    return temperature_c >= TEMPERATURE_THRESHOLD;
}

bool is_battery_critical(float battery_percent) {
    return battery_percent <= BATTERY_MIN_THRESHOLD;
}

void evaluate_system_state(SensorReadings readings) {
    printf("Evaluating embedded resilience monitor...\n");
    printf("Water Level: %.2f cm\n", readings.water_level_cm);
    printf("Temperature: %.2f C\n", readings.temperature_c);
    printf("Battery: %.2f%%\n", readings.battery_percent);

    if (is_water_risk(readings.water_level_cm)) {
        printf("ALERT: Water level exceeded infrastructure risk threshold.\n");
    } else {
        printf("STATUS: Water level within acceptable range.\n");
    }

    if (is_temperature_risk(readings.temperature_c)) {
        printf("ALERT: Temperature exceeded resilience threshold.\n");
    } else {
        printf("STATUS: Temperature within acceptable range.\n");
    }

    if (is_battery_critical(readings.battery_percent)) {
        printf("ALERT: Battery below minimum safe operating threshold.\n");
    } else {
        printf("STATUS: Battery level acceptable.\n");
    }
}

int main(void) {
    SensorReadings readings = {
        .water_level_cm = 81.4,
        .temperature_c = 39.2,
        .battery_percent = 18.0
    };

    evaluate_system_state(readings);
    return 0;
}
