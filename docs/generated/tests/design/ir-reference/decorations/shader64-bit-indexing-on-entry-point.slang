//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#shader64bitindexing
//META: purpose=A [Shader64BitIndexing] attribute written on the entry point itself produces a nullary shader64BitIndexing decoration on that entry-point function.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the first of the three spellings the doc says are handled
// uniformly, and the decoration's nullary shape. The CHECK pins the bare
// `[shader64BitIndexing]` line followed by `func %main`, which is the
// entry-point-scoped placement the SPIR-V execution mode requires.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[Shader64BitIndexing]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: [shader64BitIndexing]
// CHECK: [nameHint("main")]
// CHECK: func %main
