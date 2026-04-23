/*
 * embedded_industrial_reporting_stub.c
 *
 * Optional embedded C example for low-resource industrial reporting.
 */

#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float standards_alignment_index;
    float equipment_readiness_index;
} IndustrialReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    IndustrialReadings readings = {0.79f, 0.64f};

    printf("Embedded Industrial Reporting Stub\n");
    printf("Standards Alignment Index: %.2f\n", readings.standards_alignment_index);
    printf("Equipment Readiness Index: %.2f\n", readings.equipment_readiness_index);

    if (!valid_index(readings.standards_alignment_index) || !valid_index(readings.equipment_readiness_index)) {
        printf("ALERT: Industrial reporting index out of range.\n");
    } else {
        printf("STATUS: Industrial reporting record valid.\n");
    }

    return 0;
}
