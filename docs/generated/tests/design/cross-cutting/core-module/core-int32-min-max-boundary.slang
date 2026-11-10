//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/core-module.md#core-module
//META: purpose=int32_t holds its documented MIN and MAX end points, -2147483648 and 2147483647.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the core module's 32-bit signed base type spans the full
// two's-complement range at both edges. MIN is written as
// (-2147483647 - 1) so no literal exceeds the type on the way in, and
// both edges are printed; the CHECK pins the exact end points, which
// would shift if the alias resolved to a narrower or unsigned type.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int32_t maxv = int32_t(2147483647);
    int32_t minv = int32_t(-2147483647) - int32_t(1);
    // CHECK: min=-2147483648 max=2147483647
    printf("min=%d max=%d\n", minv, maxv);
}
