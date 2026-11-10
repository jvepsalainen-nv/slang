//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/core-module.md#core-module
//META: purpose=float32_t represents positive and negative infinity as the result of dividing a non-zero value by zero.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the core module's 32-bit float base type carries IEEE
// infinities rather than trapping or clamping. Both signed infinities
// are produced by dividing by a zero the compiler cannot fold away
// (the divisor is derived from a runtime value), and the CHECK pins
// the printed `inf` / `-inf` spellings plus the ordering property
// that +inf compares greater than the largest finite float.

//TEST:INTERPRET(filecheck=CHECK):

float32_t divide(float32_t a, float32_t b) { return a / b; }

void main()
{
    float32_t zero = float32_t(0.0);
    float32_t pinf = divide(float32_t(1.0), zero);
    float32_t ninf = divide(float32_t(-1.0), zero);
    // CHECK: pinf=inf ninf=-inf aboveMax=1
    printf("pinf=%f ninf=%f aboveMax=%d\n",
           pinf, ninf, int(pinf > float32_t.maxValue));
}
