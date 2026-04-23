/*
 * embedded_fiscal_reporting_stub.c
 *
 * Optional embedded C example for low-resource local reporting or audit support.
 * Intended use:
 * - basic offline validation of debt-service entries
 * - simple field or ministry-side reporting node
 */

#include <stdio.h>
#include <stdbool.h>

#define MAX_RATIO 100.0
#define MIN_RATIO 0.0

typedef struct {
    float debt_service_revenue_ratio;
    float interest_revenue_ratio;
} FiscalReadings;

bool valid_ratio(float value) {
    return value >= MIN_RATIO && value <= MAX_RATIO;
}

int main(void) {
    FiscalReadings readings = {18.4, 7.8};

    printf("Embedded Fiscal Reporting Stub\n");
    printf("Debt Service / Revenue Ratio: %.2f\n", readings.debt_service_revenue_ratio);
    printf("Interest / Revenue Ratio: %.2f\n", readings.interest_revenue_ratio);

    if (!valid_ratio(readings.debt_service_revenue_ratio) || !valid_ratio(readings.interest_revenue_ratio)) {
        printf("ALERT: Fiscal ratio out of allowed range.\n");
    } else {
        printf("STATUS: Fiscal ratios ready for transmission.\n");
    }

    return 0;
}
