/*
 * embedded_reporting_stub.c
 *
 * Optional embedded C example for local data collection or low-resource reporting.
 * Intended use:
 * - simple field device or local collection node
 * - basic validation before upstream transmission
 */

#include <stdio.h>
#include <stdbool.h>

#define MAX_INDICATOR_VALUE 100.0
#define MIN_INDICATOR_VALUE 0.0

typedef struct {
    float indicator_value;
    int reporting_year;
} IndicatorReading;

bool valid_indicator_value(float value) {
    return value >= MIN_INDICATOR_VALUE && value <= MAX_INDICATOR_VALUE;
}

int main(void) {
    IndicatorReading reading = {71.8, 2026};

    printf("Embedded Reporting Stub\n");
    printf("Indicator Value: %.2f\n", reading.indicator_value);
    printf("Reporting Year: %d\n", reading.reporting_year);

    if (!valid_indicator_value(reading.indicator_value)) {
        printf("ALERT: Indicator value out of allowed range.\n");
    } else {
        printf("STATUS: Indicator value ready for transmission.\n");
    }

    return 0;
}
