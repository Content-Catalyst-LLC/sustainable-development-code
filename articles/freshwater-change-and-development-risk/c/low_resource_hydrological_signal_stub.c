#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float streamflow_signal_index;
    float soil_moisture_signal_index;
} WaterReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    WaterReadings readings = {0.74f, 0.63f};

    printf("Low-Resource Hydrological Signal Stub\n");
    printf("Streamflow Signal Index: %.2f\n", readings.streamflow_signal_index);
    printf("Soil Moisture Signal Index: %.2f\n", readings.soil_moisture_signal_index);

    if (!valid_index(readings.streamflow_signal_index) || !valid_index(readings.soil_moisture_signal_index)) {
        printf("ALERT: Hydrological signal out of range.\n");
    } else {
        printf("STATUS: Hydrological signal record valid.\n");
    }

    return 0;
}
