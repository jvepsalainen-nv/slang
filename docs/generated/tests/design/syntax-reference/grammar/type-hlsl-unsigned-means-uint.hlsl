//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#types
//META: purpose=In HLSL source `unsigned` and `unsigned int` both parse as the `uint` type.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies HLSL-only `unsigned` spellings: the HLSL source stores 3 + 4 via
// `unsigned` and `unsigned int` locals; CHECK asserts the buffer element is
// uint and the folded sum 7U reaches the output.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -stage compute -entry main

RWStructuredBuffer<uint> outputBuffer;

[numthreads(1, 1, 1)]
void main()
{
    unsigned x = 3;
    unsigned int y = 4;
    outputBuffer[0] = x + y;
}

// CHECK: RWStructuredBuffer<uint
// CHECK: 7U
