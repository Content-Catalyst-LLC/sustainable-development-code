/*
 * embedded_finance_reporting_stub.c
 *
 * Optional embedded C example for low-resource local project reporting.
 */

#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float taxonomy_alignment_index;
    float implementation_status_index;
} FinanceReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    FinanceReadings readings = {0.82f, 0.67f};

    printf("Embedded Finance Reporting Stub\n");
    printf("Taxonomy Alignment Index: %.2f\n", readings.taxonomy_alignment_index);
    printf("Implementation Status Index: %.2f\n", readings.implementation_status_index);

    if (!valid_index(readings.taxonomy_alignment_index) || !valid_index(readings.implementation_status_index)) {
        printf("ALERT: Finance reporting index out of range.\n");
    } else {
        printf("STATUS: Finance reporting record valid.\n");
    }

    return 0;
}
