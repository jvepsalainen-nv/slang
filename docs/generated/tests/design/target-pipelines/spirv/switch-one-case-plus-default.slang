//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#opswitch-case-literals-follow-the-selector-width
//META: purpose=A switch with exactly one case plus default still emits OpSwitch (lower edge of case count) with one labeled target and one default target.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: minimum non-trivial switch shape (1 case + default).
// Verifies that SPIR-V emit does not rewrite a single-case
// switch into a plain if/else.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int v = int(tid.x);
    int r;
    switch (v) {
        case 0:  r = 100; break;
        default: r = -1;  break;
    }
    outBuf[tid.x] = r;
}

// CHECK: OpSwitch %{{[a-zA-Z_0-9]+}} %{{[a-zA-Z_0-9]+}} 0 %{{[a-zA-Z_0-9]+}}
