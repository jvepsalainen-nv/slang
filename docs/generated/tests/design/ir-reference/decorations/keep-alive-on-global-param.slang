//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#keepalivedecoration
//META: purpose=The front-end attaches a keepAlive decoration to a global_param so it survives DCE even with no in-IR use chain reaching it.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the same DCE-suppression role on a global parameter that the
// entry point never reads: `unusedParam` has no use at all, so its survival
// in the dump is only explicable by a `keepAlive` marker. The CHECK asserts
// the decoration exists in a module whose only unreferenced declaration is
// that parameter.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;
uniform int unusedParam;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: [keepAlive]
