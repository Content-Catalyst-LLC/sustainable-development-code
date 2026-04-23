/*
 * embedded_ecological_stress_monitor.c
 *
 * Embedded C example for monitoring ecological stress at the infrastructure edge.
 * Intended use:
 * - water stress or heat monitoring node
 * - simple fail-safe alert logic where central systems are delayed
 */

#include <stdio.h>
#include <stdbool.h>

#define WATER_STRESS_THRESHOLD 80.0
#define HEAT_STRESS_THRESHOLD 42.0
#define POWER_MIN_THRESHOLD 18.0

typedef struct {
    float water_stress_level;
    float temperature_c;
    float backup_power_percent;
} StressReadings;

bool water_stress_risk(float level) {
    return level >= WATER_STRESS_THRESHOLD;
}

bool heat_stress_risk(float temp) {
    return temp >= HEAT_STRESS_THRESHOLD;
}

bool low_power(float battery) {
    return battery <= POWER_MIN_THRESHOLD;
}

int main(void) {
    StressReadings readings = {82.4, 40.8, 16.9};

    printf("Embedded Ecological Stress Monitor\n");
    printf("Water Stress Level: %.2f\n", readings.water_stress_level);
    printf("Temperature: %.2f C\n", readings.temperature_c);
    printf("Backup Power: %.2f%%\n", readings.backup_power_percent);

    if (water_stress_risk(readings.water_stress_level)) {
        printf("ALERT: Water stress threshold exceeded.\n");
    }

    if (heat_stress_risk(readings.temperature_c)) {
        printf("ALERT: Heat stress threshold exceeded.\n");
    }

    if (low_power(readings.backup_power_percent)) {
        printf("ALERT: Backup power critically low.\n");
    }

    return 0;
}
