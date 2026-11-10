//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#wgsl
//META: purpose=WGSL also sets `supportsSwitchFallThrough` to false, so two labels sharing one body are emitted as a single comma-separated WGSL case selector instead of the stacked empty-case form the other C-like backends use.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the second half of WGSL's switch divergence. `case 0: case 1:` is
// the one fall-through shape Slang allows, and WGSL has no way to express it
// as two labels, so the emitter must fold them into one selector list. The
// WGSL prefix asserts the merged `case i32(0), i32(1):` form; the HLSL, Metal
// and GLSL prefixes assert the same source still emits two stacked labels
// there, so the test fails if the merge leaked into the shared base. GLSL is
// included as well as Metal because it spells the label value bare (`case 0:`)
// rather than through a constructor, which is a different print path in the
// shared base. SPIR-V is not exercised: `OpSwitch` carries a flat
// literal-to-label list with no notion of an empty stacked case, so the
// distinction the claim draws does not exist there (see the README's
// Untested-claims row).

//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int r = 0;
    switch (int(tid.x))
    {
    case 0:
    case 1:
        r = 10;
        break;
    default:
        r = 30;
        break;
    }
    outBuf[0] = r;
}

// WGSL: case i32(0), i32(1):
// WGSL-NOT: case i32(1):

// HLSL: case int(0):
// HLSL-NEXT: case int(1):

// METAL: case int(0):
// METAL-NEXT: case int(1):

// GLSL: case 0:
// GLSL-NEXT: case 1:
