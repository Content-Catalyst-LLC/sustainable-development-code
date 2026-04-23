#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float conversion_signal_index;
    float degradation_signal_index;
} LandReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    LandReadings readings = {0.73f, 0.64f};

    printf("Low-Resource Land Monitoring Signal Stub\n");
    printf("Conversion Signal Index: %.2f\n", readings.conversion_signal_index);
    printf("Degradation Signal Index: %.2f\n", readings.degradation_signal_index);

    if (!valid_index(readings.conversion_signal_index) || !valid_index(readings.degradation_signal_index)) {
        printf("ALERT: Land monitoring signal out of range.\n");
    } else {
        printf("STATUS: Land monitoring signal record valid.\n");
    }

    return 0;
}
