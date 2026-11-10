//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#attr-family
//META: purpose=The stage attribute tags an entry-point varLayout with a single pipeline-stage integer literal.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the stage tag and its arity. The entry point's parameter var layout
// carries the attribute; the CHECK pins the closing parenthesis after one
// operand, so an attribute with a different operand count would not match, and
// the captured id is resolved back to a `stage` definition from within the
// var layout that owns it.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: = varLayout(%{{[0-9]+}}, %{{[0-9]+}}, %[[STAGE:[0-9]+]])
// The literal is a `Stage` enumerator, so a compute entry point prints as 6.
// CHECK: %[[STAGE]]{{.*}}= stage(6 : Int)
