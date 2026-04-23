#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float housing_signal_index;
    float service_signal_index;
} ServiceReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    ServiceReadings readings = {0.68f, 0.72f};

    printf("Low-Resource Service Signal Stub\n");
    printf("Housing Signal Index: %.2f\n", readings.housing_signal_index);
    printf("Service Signal Index: %.2f\n", readings.service_signal_index);

    if (!valid_index(readings.housing_signal_index) || !valid_index(readings.service_signal_index)) {
        printf("ALERT: Service signal out of range.\n");
    } else {
        printf("STATUS: Service signal record valid.\n");
    }

    return 0;
}
