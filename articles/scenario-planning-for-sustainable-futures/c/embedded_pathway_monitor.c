/*
 * embedded_pathway_monitor.c
 *
 * Embedded C example for infrastructure-side threshold monitoring under uncertain futures.
 * Intended use:
 * - low-power flood or heat monitoring node
 * - local fail-safe alert logic when central coordination is delayed
 */

#include <stdio.h>
#include <stdbool.h>

#define FLOOD_THRESHOLD_CM 80.0
#define HEAT_THRESHOLD_C 43.0
#define POWER_MIN_THRESHOLD 18.0

typedef struct {
    float flood_level_cm;
    float temperature_c;
    float backup_power_percent;
} EdgeReadings;

bool flood_risk(float level) {
    return level >= FLOOD_THRESHOLD_CM;
}

bool heat_risk(float temp) {
    return temp >= HEAT_THRESHOLD_C;
}

bool low_power(float battery) {
    return battery <= POWER_MIN_THRESHOLD;
}

int main(void) {
    EdgeReadings readings = {84.2, 40.1, 16.5};

    printf("Scenario Pathway Edge Monitor\n");
    printf("Flood Level: %.2f cm\n", readings.flood_level_cm);
    printf("Temperature: %.2f C\n", readings.temperature_c);
    printf("Backup Power: %.2f%%\n", readings.backup_power_percent);

    if (flood_risk(readings.flood_level_cm)) {
        printf("ALERT: Flood threshold exceeded.\n");
    }

    if (heat_risk(readings.temperature_c)) {
        printf("ALERT: Heat threshold exceeded.\n");
    }

    if (low_power(readings.backup_power_percent)) {
        printf("ALERT: Backup power critically low.\n");
    }

    return 0;
}
