#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float grievance_signal_index;
    float meeting_participation_index;
} CivicReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    CivicReadings readings = {0.72f, 0.68f};

    printf("Low-Resource Civic Feedback Stub\n");
    printf("Grievance Signal Index: %.2f\n", readings.grievance_signal_index);
    printf("Meeting Participation Index: %.2f\n", readings.meeting_participation_index);

    if (!valid_index(readings.grievance_signal_index) || !valid_index(readings.meeting_participation_index)) {
        printf("ALERT: Civic feedback reading out of range.\n");
    } else {
        printf("STATUS: Civic feedback record valid.\n");
    }

    return 0;
}
