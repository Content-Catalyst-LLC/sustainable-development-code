#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float interaction_signal_index;
    float feedback_signal_index;
} InteractionReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    InteractionReadings readings = {0.71f, 0.65f};

    printf("Low-Resource Interaction Signal Stub\n");
    printf("Interaction Signal Index: %.2f\n", readings.interaction_signal_index);
    printf("Feedback Signal Index: %.2f\n", readings.feedback_signal_index);

    if (!valid_index(readings.interaction_signal_index) || !valid_index(readings.feedback_signal_index)) {
        printf("ALERT: Interaction signal out of range.\n");
    } else {
        printf("STATUS: Interaction signal record valid.\n");
    }

    return 0;
}
