#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float service_signal_index;
    float drainage_signal_index;
} UrbanReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    UrbanReadings readings = {0.72f, 0.67f};

    printf("Low-Resource Urban Service Signal Stub\n");
    printf("Service Signal Index: %.2f\n", readings.service_signal_index);
    printf("Drainage Signal Index: %.2f\n", readings.drainage_signal_index);

    if (!valid_index(readings.service_signal_index) || !valid_index(readings.drainage_signal_index)) {
        printf("ALERT: Urban-service signal out of range.\n");
    } else {
        printf("STATUS: Urban-service signal record valid.\n");
    }

    return 0;
}
