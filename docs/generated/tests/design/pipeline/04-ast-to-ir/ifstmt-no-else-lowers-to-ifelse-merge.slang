//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=An IfStmt with no `else` clause still lowers to an `ifElse(...)` terminator carrying an explicit merge operand; the missing else-branch is represented by an empty/false-block jumping directly to the merge.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: if-shape axis — single-armed if. The doc lists `IfStmt`
// as a structured branch with an explicit join operand. An `if`
// without an `else` still emits an `ifElse(...)` instruction with a
// merge block; the absent else-branch becomes a no-op false block
// that branches to the merge.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int r = 0;
    if (a > 0)
        r = 1;
    buf[0] = r;
}

// CHECK-LABEL: func %main
// CHECK: ifElse(%{{.*}}, %{{.*}}, %{{.*}}, %{{.*}})
