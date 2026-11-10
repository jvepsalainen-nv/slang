//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#nodes
//META: purpose=The NullPtrType of the `nullptr` literal is accepted at a pointer-typed target without an explicit cast and compares equal to a null pointer.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `nullptr` has its own type which converts to `T*`: an
// `int*` local is initialised from the bare literal and then compared
// against it. Both the comparison result and a comparison against a
// real pointee address are written to a buffer; CHECK asserts 1 then 0,
// so a `nullptr` that silently became a valid address would fail.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

//TEST_INPUT: set src = ubuffer(data=[7], stride=4)
uniform int* src;
//TEST_INPUT: set outBuf = out ubuffer(data=[0 0], stride=4)
RWStructuredBuffer<int> outBuf;

[numthreads(1, 1, 1)]
void computeMain()
{
    int* p = nullptr;
    // CHECK: 1
    outBuf[0] = (p == nullptr) ? 1 : 0;
    p = src;
    // CHECK: 0
    outBuf[1] = (p == nullptr) ? 1 : 0;
}
