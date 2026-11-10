//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/core-module.md#core-module
//META: purpose=float32_t distinguishes -0.0 from +0.0 in its bit pattern while still comparing them equal.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the core module's 32-bit float base type keeps the IEEE
// signed-zero distinction. Equality is checked first (it must hold),
// then the sign is recovered by dividing 1.0 by each zero: +0.0 yields
// +inf and -0.0 yields -inf. The CHECK pins `eq=1 posRecip=inf
// negRecip=-inf`, which separates the two zeros without needing a
// bit-cast intrinsic.

//TEST:INTERPRET(filecheck=CHECK):

float32_t recip(float32_t x) { return float32_t(1.0) / x; }

void main()
{
    float32_t pz = float32_t(0.0);
    float32_t nz = -pz;
    // CHECK: eq=1 posRecip=inf negRecip=-inf
    printf("eq=%d posRecip=%f negRecip=%f\n", int(pz == nz), recip(pz), recip(nz));
}
