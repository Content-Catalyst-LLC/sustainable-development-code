/*
 * offline_service_node_stub.c
 *
 * Optional embedded C example for low-resource offline public-service devices.
 */

#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float sync_status_index;
    float device_integrity_index;
} OfflineNodeReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    OfflineNodeReadings readings = {0.76f, 0.81f};

    printf("Offline Service Node Stub\n");
    printf("Sync Status Index: %.2f\n", readings.sync_status_index);
    printf("Device Integrity Index: %.2f\n", readings.device_integrity_index);

    if (!valid_index(readings.sync_status_index) || !valid_index(readings.device_integrity_index)) {
        printf("ALERT: Offline service node reading out of range.\n");
    } else {
        printf("STATUS: Offline service node record valid.\n");
    }

    return 0;
}
