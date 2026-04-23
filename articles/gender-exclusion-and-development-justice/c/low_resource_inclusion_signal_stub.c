#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float education_signal_index;
    float autonomy_signal_index;
} InclusionReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    InclusionReadings readings = {0.73f, 0.62f};

    printf("Low-Resource Inclusion Signal Stub\n");
    printf("Education Signal Index: %.2f\n", readings.education_signal_index);
    printf("Autonomy Signal Index: %.2f\n", readings.autonomy_signal_index);

    if (!valid_index(readings.education_signal_index) || !valid_index(readings.autonomy_signal_index)) {
        printf("ALERT: Inclusion signal out of range.\n");
    } else {
        printf("STATUS: Inclusion signal record valid.\n");
    }

    return 0;
}
