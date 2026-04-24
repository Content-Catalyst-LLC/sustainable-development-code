#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float throughput_signal_index;
    float delay_signal_index;
} ThroughputReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    ThroughputReadings readings = {0.74f, 0.63f};

    printf("Low-Resource Throughput Signal Stub\n");
    printf("Throughput Signal Index: %.2f\n", readings.throughput_signal_index);
    printf("Delay Signal Index: %.2f\n", readings.delay_signal_index);

    if (!valid_index(readings.throughput_signal_index) || !valid_index(readings.delay_signal_index)) {
        printf("ALERT: Throughput signal out of range.\n");
    } else {
        printf("STATUS: Throughput signal record valid.\n");
    }

    return 0;
}
