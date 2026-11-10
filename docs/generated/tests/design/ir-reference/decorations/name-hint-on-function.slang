//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#namehint--namehintdecoration
//META: purpose=A user-named function carries a nameHint decoration with the source identifier as a string literal operand.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `nameHint` carries the human-readable source identifier as
// a string operand. The CHECK pins `[nameHint("doubleIt")]` and then the
// `func %doubleIt` line it precedes, so the string is shown to be attached
// to the function it names rather than merely present in the module.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

int doubleIt(int x) { return x + x; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = doubleIt(int(tid.x));
}

// CHECK: [nameHint("doubleIt")]
// CHECK: func %doubleIt
