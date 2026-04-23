/*
 * low_resource_system_signal_stub.c
 *
 * Optional embedded C example for low-resource infrastructure or system-signal nodes
 * that feed into higher-level coordination monitoring.
 */

#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float infrastructure_stress_index;
    float local_service_disruption_index;
} SystemSignalReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    SystemSignalReadings readings = {0.64f, 0.71f};

    printf("Low-Resource System Signal Stub\n");
    printf("Infrastructure Stress Index: %.2f\n", readings.infrastructure_stress_index);
    printf("Local Service Disruption Index: %.2f\n", readings.local_service_disruption_index);

    if (!valid_index(readings.infrastructure_stress_index) || !valid_index(readings.local_service_disruption_index)) {
        printf("ALERT: System-signal reading out of range.\n");
    } else {
        printf("STATUS: System-signal record valid.\n");
    }

    return 0;
}
