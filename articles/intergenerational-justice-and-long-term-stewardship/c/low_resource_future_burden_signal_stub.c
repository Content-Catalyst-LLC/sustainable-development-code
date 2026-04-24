#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float future_burden_signal_index;
    float stewardship_signal_index;
} BurdenReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    BurdenReadings readings = {0.73f, 0.61f};

    printf("Low-Resource Future Burden Signal Stub\n");
    printf("Future Burden Signal Index: %.2f\n", readings.future_burden_signal_index);
    printf("Stewardship Signal Index: %.2f\n", readings.stewardship_signal_index);

    if (!valid_index(readings.future_burden_signal_index) || !valid_index(readings.stewardship_signal_index)) {
        printf("ALERT: Future burden signal out of range.\n");
    } else {
        printf("STATUS: Future burden signal record valid.\n");
    }

    return 0;
}
