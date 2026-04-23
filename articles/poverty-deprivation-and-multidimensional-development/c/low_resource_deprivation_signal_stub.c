#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float nutrition_signal_index;
    float sanitation_signal_index;
} DeprivationReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    DeprivationReadings readings = {0.71f, 0.66f};

    printf("Low-Resource Deprivation Signal Stub\n");
    printf("Nutrition Signal Index: %.2f\n", readings.nutrition_signal_index);
    printf("Sanitation Signal Index: %.2f\n", readings.sanitation_signal_index);

    if (!valid_index(readings.nutrition_signal_index) || !valid_index(readings.sanitation_signal_index)) {
        printf("ALERT: Deprivation signal out of range.\n");
    } else {
        printf("STATUS: Deprivation signal record valid.\n");
    }

    return 0;
}
