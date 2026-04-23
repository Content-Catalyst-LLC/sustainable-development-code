#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float climate_signal_index;
    float biosphere_signal_index;
} EarthSystemReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    EarthSystemReadings readings = {0.78f, 0.74f};

    printf("Low-Resource Earth-System Signal Stub\n");
    printf("Climate Signal Index: %.2f\n", readings.climate_signal_index);
    printf("Biosphere Signal Index: %.2f\n", readings.biosphere_signal_index);

    if (!valid_index(readings.climate_signal_index) || !valid_index(readings.biosphere_signal_index)) {
        printf("ALERT: Earth-system signal out of range.\n");
    } else {
        printf("STATUS: Earth-system signal record valid.\n");
    }

    return 0;
}
