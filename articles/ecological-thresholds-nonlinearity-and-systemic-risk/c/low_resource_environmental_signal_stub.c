#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float pressure_signal_index;
    float moisture_signal_index;
} EnvironmentalReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    EnvironmentalReadings readings = {0.74f, 0.63f};

    printf("Low-Resource Environmental Signal Stub\n");
    printf("Pressure Signal Index: %.2f\n", readings.pressure_signal_index);
    printf("Moisture Signal Index: %.2f\n", readings.moisture_signal_index);

    if (!valid_index(readings.pressure_signal_index) || !valid_index(readings.moisture_signal_index)) {
        printf("ALERT: Environmental signal out of range.\n");
    } else {
        printf("STATUS: Environmental signal record valid.\n");
    }

    return 0;
}
