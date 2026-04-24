#include <cstdint>
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/micro/micro_mutable_op_resolver.h"
#include "tensorflow/lite/schema/schema_generated.h"
#include "tensorflow/lite/version.h"

// Replace with your converted model array.
extern const unsigned char g_model[];
extern const int g_model_len;

// Static tensor arena: no dynamic allocation.
constexpr int kTensorArenaSize = 8 * 1024;
alignas(16) uint8_t tensor_arena[kTensorArenaSize];

int main() {
    const tflite::Model* model = tflite::GetModel(g_model);
    if (model->version() != TFLITE_SCHEMA_VERSION) {
        return 1;
    }

    tflite::MicroMutableOpResolver<4> resolver;
    resolver.AddFullyConnected();
    resolver.AddReshape();
    resolver.AddSoftmax();
    resolver.AddQuantize();

    tflite::MicroInterpreter interpreter(
        model, resolver, tensor_arena, kTensorArenaSize
    );

    if (interpreter.AllocateTensors() != kTfLiteOk) {
        return 2;
    }

    TfLiteTensor* input = interpreter.input(0);
    input->data.int8[0] = 12;
    input->data.int8[1] = -4;
    input->data.int8[2] = 7;
    input->data.int8[3] = 3;

    if (interpreter.Invoke() != kTfLiteOk) {
        return 3;
    }

    TfLiteTensor* output = interpreter.output(0);
    int8_t anomaly_score = output->data.int8[0];

    if (anomaly_score > 64) {
        // Escalate event to radio or gateway.
    }

    return 0;
}
