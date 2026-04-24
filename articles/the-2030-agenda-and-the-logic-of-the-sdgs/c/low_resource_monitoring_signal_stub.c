#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float monitoring_signal_index;
    float alignment_signal_index;
} MonitoringReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    MonitoringReadings readings = {0.68f, 0.62f};

    printf("Low-Resource Monitoring Signal Stub\n");
    printf("Monitoring Signal Index: %.2f\n", readings.monitoring_signal_index);
    printf("Alignment Signal Index: %.2f\n", readings.alignment_signal_index);

    if (!valid_index(readings.monitoring_signal_index) || !valid_index(readings.alignment_signal_index)) {
        printf("ALERT: Monitoring signal out of range.\n");
    } else {
        printf("STATUS: Monitoring signal record valid.\n");
    }

    return 0;
}
