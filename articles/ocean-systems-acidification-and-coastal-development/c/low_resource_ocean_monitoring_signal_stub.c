#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float acidity_signal_index;
    float oxygen_signal_index;
} OceanReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    OceanReadings readings = {0.73f, 0.62f};

    printf("Low-Resource Ocean Monitoring Signal Stub\n");
    printf("Acidity Signal Index: %.2f\n", readings.acidity_signal_index);
    printf("Oxygen Signal Index: %.2f\n", readings.oxygen_signal_index);

    if (!valid_index(readings.acidity_signal_index) || !valid_index(readings.oxygen_signal_index)) {
        printf("ALERT: Ocean-monitoring signal out of range.\n");
    } else {
        printf("STATUS: Ocean-monitoring signal record valid.\n");
    }

    return 0;
}
