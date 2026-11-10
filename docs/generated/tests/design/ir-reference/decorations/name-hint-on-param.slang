//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#naming-and-provenance
//META: purpose=A nameHint decoration also attaches to function parameters carrying the declared parameter name.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `nameHint` is not restricted to top-level symbols: the
// entry point's parameter gets one too. The CHECK pins the decoration and
// the `param %tid` line it precedes, which is the shape a backend relies on
// when it names the emitted variable after the source parameter.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: [nameHint("tid")]
// CHECK: param %tid
