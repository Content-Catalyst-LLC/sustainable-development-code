#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float delivery_signal_index;
    float queue_signal_index;
} DeliveryReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    DeliveryReadings readings = {0.71f, 0.65f};

    printf("Low-Resource Delivery Signal Stub\n");
    printf("Delivery Signal Index: %.2f\n", readings.delivery_signal_index);
    printf("Queue Signal Index: %.2f\n", readings.queue_signal_index);

    if (!valid_index(readings.delivery_signal_index) || !valid_index(readings.queue_signal_index)) {
        printf("ALERT: Delivery signal out of range.\n");
    } else {
        printf("STATUS: Delivery signal record valid.\n");
    }

    return 0;
}
