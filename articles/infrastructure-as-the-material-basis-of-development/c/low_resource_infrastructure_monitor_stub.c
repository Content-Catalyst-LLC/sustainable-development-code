/*
 * low_resource_infrastructure_monitor_stub.c
 *
 * Optional embedded C example for low-resource infrastructure-monitoring nodes.
 */

#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float outage_recovery_index;
    float maintenance_status_index;
} InfrastructureReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    InfrastructureReadings readings = {0.73f, 0.81f};

    printf("Low-Resource Infrastructure Monitor Stub\n");
    printf("Outage Recovery Index: %.2f\n", readings.outage_recovery_index);
    printf("Maintenance Status Index: %.2f\n", readings.maintenance_status_index);

    if (!valid_index(readings.outage_recovery_index) || !valid_index(readings.maintenance_status_index)) {
        printf("ALERT: Infrastructure-monitor reading out of range.\n");
    } else {
        printf("STATUS: Infrastructure-monitor record valid.\n");
    }

    return 0;
}
