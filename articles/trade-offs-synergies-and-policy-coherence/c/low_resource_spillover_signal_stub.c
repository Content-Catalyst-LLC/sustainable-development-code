#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float spillover_signal_index;
    float coordination_signal_index;
} SpilloverReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    SpilloverReadings readings = {0.69f, 0.58f};

    printf("Low-Resource Spillover Signal Stub\n");
    printf("Spillover Signal Index: %.2f\n", readings.spillover_signal_index);
    printf("Coordination Signal Index: %.2f\n", readings.coordination_signal_index);

    if (!valid_index(readings.spillover_signal_index) || !valid_index(readings.coordination_signal_index)) {
        printf("ALERT: Spillover signal out of range.\n");
    } else {
        printf("STATUS: Spillover signal record valid.\n");
    }

    return 0;
}
