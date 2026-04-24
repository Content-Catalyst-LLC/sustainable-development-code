#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float wellbeing_signal_index;
    float viability_signal_index;
} ViabilityReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    ViabilityReadings readings = {0.69f, 0.63f};

    printf("Low-Resource Viability Signal Stub\n");
    printf("Wellbeing Signal Index: %.2f\n", readings.wellbeing_signal_index);
    printf("Viability Signal Index: %.2f\n", readings.viability_signal_index);

    if (!valid_index(readings.wellbeing_signal_index) || !valid_index(readings.viability_signal_index)) {
        printf("ALERT: Viability signal out of range.\n");
    } else {
        printf("STATUS: Viability signal record valid.\n");
    }

    return 0;
}
