//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=`[unroll]` on a loop appears as an unroll attribute in the emitted code.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the same loop-hint claim onto the GLSL back end, where the hint
// is spelled with the C++-attribute syntax. CHECK pins that token with the
// brackets escaped, since FileCheck reads a bare double bracket as a variable
// reference, proving the hint survives GLSL codegen too.

//TEST:SIMPLE(filecheck=CHECK):-target glsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[numthreads(1,1,1)]
void main()
{
    int total = 0;
    [unroll]
    for (int i = 0; i < 4; ++i)
    {
        total += i;
    }
    outBuf[0] = total;
}

//CHECK: {{\[\[}}unroll{{\]\]}}
