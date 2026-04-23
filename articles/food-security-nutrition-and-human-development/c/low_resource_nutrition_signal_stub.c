#include <stdio.h>
#include <stdbool.h>

#define MIN_INDEX 0.0
#define MAX_INDEX 1.0

typedef struct {
    float food_access_signal_index;
    float nutrition_signal_index;
} NutritionReadings;

bool valid_index(float value) {
    return value >= MIN_INDEX && value <= MAX_INDEX;
}

int main(void) {
    NutritionReadings readings = {0.71f, 0.66f};

    printf("Low-Resource Nutrition Signal Stub\n");
    printf("Food Access Signal Index: %.2f\n", readings.food_access_signal_index);
    printf("Nutrition Signal Index: %.2f\n", readings.nutrition_signal_index);

    if (!valid_index(readings.food_access_signal_index) || !valid_index(readings.nutrition_signal_index)) {
        printf("ALERT: Nutrition signal out of range.\n");
    } else {
        printf("STATUS: Nutrition signal record valid.\n");
    }

    return 0;
}
