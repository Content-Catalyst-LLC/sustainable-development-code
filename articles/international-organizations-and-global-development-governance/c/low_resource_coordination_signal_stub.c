#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float coordination_signal_index;
    float implementation_signal_index;
} GovernanceReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    GovernanceReadings readings = {0.69f, 0.66f};

    printf("Low-Resource Coordination Signal Stub\n");
    printf("Coordination Signal Index: %.2f\n", readings.coordination_signal_index);
    printf("Implementation Signal Index: %.2f\n", readings.implementation_signal_index);

    if (!valid_index(readings.coordination_signal_index) || !valid_index(readings.implementation_signal_index)) {
        printf("ALERT: Governance signal out of range.\n");
    } else {
        printf("STATUS: Governance signal record valid.\n");
    }

    return 0;
}
