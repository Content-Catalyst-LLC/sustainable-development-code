#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float need_signal_index;
    float stewardship_signal_index;
} StewardshipReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    StewardshipReadings readings = {0.72f, 0.64f};

    printf("Low-Resource Stewardship Signal Stub\n");
    printf("Need Signal Index: %.2f\n", readings.need_signal_index);
    printf("Stewardship Signal Index: %.2f\n", readings.stewardship_signal_index);

    if (!valid_index(readings.need_signal_index) || !valid_index(readings.stewardship_signal_index)) {
        printf("ALERT: Stewardship signal out of range.\n");
    } else {
        printf("STATUS: Stewardship signal record valid.\n");
    }

    return 0;
}
