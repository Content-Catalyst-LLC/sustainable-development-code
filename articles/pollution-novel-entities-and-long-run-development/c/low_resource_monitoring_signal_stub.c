#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float waste_signal_index;
    float toxicity_signal_index;
} PollutionReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    PollutionReadings readings = {0.74f, 0.63f};

    printf("Low-Resource Monitoring Signal Stub\n");
    printf("Waste Signal Index: %.2f\n", readings.waste_signal_index);
    printf("Toxicity Signal Index: %.2f\n", readings.toxicity_signal_index);

    if (!valid_index(readings.waste_signal_index) || !valid_index(readings.toxicity_signal_index)) {
        printf("ALERT: Monitoring signal out of range.\n");
    } else {
        printf("STATUS: Monitoring signal record valid.\n");
    }

    return 0;
}
