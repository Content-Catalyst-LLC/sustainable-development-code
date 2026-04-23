#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float employment_signal_index;
    float informality_signal_index;
} LabourReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    LabourReadings readings = {0.72f, 0.61f};

    printf("Low-Resource Labour Signal Stub\n");
    printf("Employment Signal Index: %.2f\n", readings.employment_signal_index);
    printf("Informality Signal Index: %.2f\n", readings.informality_signal_index);

    if (!valid_index(readings.employment_signal_index) || !valid_index(readings.informality_signal_index)) {
        printf("ALERT: Labour signal out of range.\n");
    } else {
        printf("STATUS: Labour signal record valid.\n");
    }

    return 0;
}
