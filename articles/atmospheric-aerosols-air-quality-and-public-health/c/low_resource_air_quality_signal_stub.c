#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float pm25_signal_index;
    float smoke_signal_index;
} AirReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    AirReadings readings = {0.76f, 0.61f};

    printf("Low-Resource Air-Quality Signal Stub\n");
    printf("PM2.5 Signal Index: %.2f\n", readings.pm25_signal_index);
    printf("Smoke Signal Index: %.2f\n", readings.smoke_signal_index);

    if (!valid_index(readings.pm25_signal_index) || !valid_index(readings.smoke_signal_index)) {
        printf("ALERT: Air-quality signal out of range.\n");
    } else {
        printf("STATUS: Air-quality signal record valid.\n");
    }

    return 0;
}
