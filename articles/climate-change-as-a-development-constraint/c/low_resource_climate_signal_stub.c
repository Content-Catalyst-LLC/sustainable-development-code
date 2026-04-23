#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float heat_signal_index;
    float hydrological_signal_index;
} ClimateReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    ClimateReadings readings = {0.76f, 0.64f};

    printf("Low-Resource Climate Signal Stub\n");
    printf("Heat Signal Index: %.2f\n", readings.heat_signal_index);
    printf("Hydrological Signal Index: %.2f\n", readings.hydrological_signal_index);

    if (!valid_index(readings.heat_signal_index) || !valid_index(readings.hydrological_signal_index)) {
        printf("ALERT: Climate signal out of range.\n");
    } else {
        printf("STATUS: Climate signal record valid.\n");
    }

    return 0;
}
