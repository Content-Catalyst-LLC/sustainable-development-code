#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float complaint_signal_index;
    float remedy_access_signal_index;
} LegalReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    LegalReadings readings = {0.70f, 0.64f};

    printf("Low-Resource Legal Access Signal Stub\n");
    printf("Complaint Signal Index: %.2f\n", readings.complaint_signal_index);
    printf("Remedy Access Signal Index: %.2f\n", readings.remedy_access_signal_index);

    if (!valid_index(readings.complaint_signal_index) || !valid_index(readings.remedy_access_signal_index)) {
        printf("ALERT: Legal access signal out of range.\n");
    } else {
        printf("STATUS: Legal access signal record valid.\n");
    }

    return 0;
}
