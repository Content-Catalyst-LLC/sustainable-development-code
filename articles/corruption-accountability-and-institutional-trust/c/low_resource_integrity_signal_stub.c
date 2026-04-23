#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float complaint_signal_index;
    float service_irregularity_index;
} IntegrityReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    IntegrityReadings readings = {0.66f, 0.71f};

    printf("Low-Resource Integrity Signal Stub\n");
    printf("Complaint Signal Index: %.2f\n", readings.complaint_signal_index);
    printf("Service Irregularity Index: %.2f\n", readings.service_irregularity_index);

    if (!valid_index(readings.complaint_signal_index) || !valid_index(readings.service_irregularity_index)) {
        printf("ALERT: Integrity signal out of range.\n");
    } else {
        printf("STATUS: Integrity signal record valid.\n");
    }

    return 0;
}
