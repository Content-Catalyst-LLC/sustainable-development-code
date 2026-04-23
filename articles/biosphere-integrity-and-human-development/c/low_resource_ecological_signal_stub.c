#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float degradation_signal_index;
    float fragmentation_signal_index;
} EcologicalReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    EcologicalReadings readings = {0.74f, 0.62f};

    printf("Low-Resource Ecological Signal Stub\n");
    printf("Degradation Signal Index: %.2f\n", readings.degradation_signal_index);
    printf("Fragmentation Signal Index: %.2f\n", readings.fragmentation_signal_index);

    if (!valid_index(readings.degradation_signal_index) || !valid_index(readings.fragmentation_signal_index)) {
        printf("ALERT: Ecological signal out of range.\n");
    } else {
        printf("STATUS: Ecological signal record valid.\n");
    }

    return 0;
}
