//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#undoparametercopy-and-transformparamstoconstref
//META: purpose=Verifies an inout int parameter still lowers to pass-by-pointer when the supplied value is int MAX (boundary value does not change the pass shape).
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: inout pointer parameter carrying an int MAX
// value. The `undoParameterCopy` rewrite produces an `inc_0(int *)`
// signature regardless of the address-space-edge value passed in.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<int> outBuf;

void inc(inout int x) { x = x + 1; }

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int s = int(2147483647);
    inc(s);
    outBuf[tid.x] = s;
}

// CHECK: inc{{[_0-9]*}}(int *
// CHECK: int(2147483647)
