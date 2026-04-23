#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float attainment_signal_index;
    float coverage_signal_index;
} DataReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    DataReadings readings = {0.77f, 0.69f};

    printf("Low-Resource Data Signal Stub\n");
    printf("Attainment Signal Index: %.2f\n", readings.attainment_signal_index);
    printf("Coverage Signal Index: %.2f\n", readings.coverage_signal_index);

    if (!valid_index(readings.attainment_signal_index) || !valid_index(readings.coverage_signal_index)) {
        printf("ALERT: Data signal out of range.\n");
    } else {
        printf("STATUS: Data signal record valid.\n");
    }

    return 0;
}
