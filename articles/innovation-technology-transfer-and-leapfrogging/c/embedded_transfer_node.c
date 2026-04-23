/*
 * embedded_transfer_node.c
 *
 * Optional embedded C example for edge deployment in digital or green infrastructure.
 * Intended use:
 * - simple local controller or field node
 * - basic reporting of deployment status and maintenance alerts
 */

#include <stdio.h>
#include <stdbool.h>

#define HEALTHY_THRESHOLD 70.0
#define POWER_MIN_THRESHOLD 20.0

typedef struct {
    float deployment_health_score;
    float backup_power_percent;
} DeploymentReadings;

bool low_health(float value) {
    return value < HEALTHY_THRESHOLD;
}

bool low_power(float battery) {
    return battery <= POWER_MIN_THRESHOLD;
}

int main(void) {
    DeploymentReadings readings = {68.5, 17.6};

    printf("Embedded Transfer Node\n");
    printf("Deployment Health Score: %.2f\n", readings.deployment_health_score);
    printf("Backup Power: %.2f%%\n", readings.backup_power_percent);

    if (low_health(readings.deployment_health_score)) {
        printf("ALERT: Deployment health below threshold.\n");
    }

    if (low_power(readings.backup_power_percent)) {
        printf("ALERT: Backup power critically low.\n");
    }

    return 0;
}
