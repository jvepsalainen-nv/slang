//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=`[numthreads(x,y,z)]` workgroup dimensions appear in the emitted entry point.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the workgroup-size claim onto GLSL, where the same attribute is
// spelled as a `layout(local_size_*)` qualifier on the input layout. CHECK
// asserts the x extent reaches the emitted GLSL, showing the attribute is
// translated per-target rather than simply copied through.

//TEST:SIMPLE(filecheck=CHECK):-target glsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[numthreads(16, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

//CHECK: local_size_x = 16
