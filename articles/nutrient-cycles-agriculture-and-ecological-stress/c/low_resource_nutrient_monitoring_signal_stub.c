#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float nitrogen_signal_index;
    float phosphorus_signal_index;
} NutrientReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    NutrientReadings readings = {0.74f, 0.62f};

    printf("Low-Resource Nutrient Monitoring Signal Stub\n");
    printf("Nitrogen Signal Index: %.2f\n", readings.nitrogen_signal_index);
    printf("Phosphorus Signal Index: %.2f\n", readings.phosphorus_signal_index);

    if (!valid_index(readings.nitrogen_signal_index) || !valid_index(readings.phosphorus_signal_index)) {
        printf("ALERT: Nutrient monitoring signal out of range.\n");
    } else {
        printf("STATUS: Nutrient monitoring signal record valid.\n");
    }

    return 0;
}
