//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#syntax
//META: purpose=Pointer arithmetic on a local array emits `OpPtrAccessChain` in SPIR-V, and explicit pointer-add syntax in CPP/CUDA, when the offset is a runtime value.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that pointer arithmetic with a runtime offset emits the correct lowered form
// per back-end: `OpPtrAccessChain` in SPIR-V assembly; pointer-add expression
// (`&arr_0[int(0)] +`) in CPP and CUDA outputs.  The offset is read from a buffer
// to prevent constant folding, ensuring the add survives to the back-end.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECKCPP):-target cpp -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECKCUDA):-target cuda -entry main -stage compute

[numthreads(1,1,1)]
void main(RWStructuredBuffer<int> inputBuf, RWStructuredBuffer<int> outputBuf)
{
    int arr[4];
    arr[0] = inputBuf[0];
    arr[1] = inputBuf[1];
    arr[2] = inputBuf[2];
    arr[3] = inputBuf[3];
    int* p = &arr[0];
    p = p + inputBuf[4];  // runtime offset — forces OpPtrAccessChain
    outputBuf[0] = *p;
}
// CHECK: OpPtrAccessChain
// CHECKCPP: &arr_0[int(0)] +
// CHECKCUDA: &arr_0[int(0)] +
