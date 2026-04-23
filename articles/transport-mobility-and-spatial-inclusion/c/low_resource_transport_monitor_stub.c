/*
 * low_resource_transport_monitor_stub.c
 *
 * Optional embedded C example for low-resource transport-monitoring nodes.
 */

#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float route_uptime_index;
    float stop_safety_index;
} TransportReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    TransportReadings readings = {0.78f, 0.69f};

    printf("Low-Resource Transport Monitor Stub\n");
    printf("Route Uptime Index: %.2f\n", readings.route_uptime_index);
    printf("Stop Safety Index: %.2f\n", readings.stop_safety_index);

    if (!valid_index(readings.route_uptime_index) || !valid_index(readings.stop_safety_index)) {
        printf("ALERT: Transport-monitor reading out of range.\n");
    } else {
        printf("STATUS: Transport-monitor record valid.\n");
    }

    return 0;
}
