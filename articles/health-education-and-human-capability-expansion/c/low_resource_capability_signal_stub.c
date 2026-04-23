#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float health_signal_index;
    float education_signal_index;
} CapabilityReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    CapabilityReadings readings = {0.72f, 0.68f};

    printf("Low-Resource Capability Signal Stub\n");
    printf("Health Signal Index: %.2f\n", readings.health_signal_index);
    printf("Education Signal Index: %.2f\n", readings.education_signal_index);

    if (!valid_index(readings.health_signal_index) || !valid_index(readings.education_signal_index)) {
        printf("ALERT: Capability signal out of range.\n");
    } else {
        printf("STATUS: Capability signal record valid.\n");
    }

    return 0;
}
