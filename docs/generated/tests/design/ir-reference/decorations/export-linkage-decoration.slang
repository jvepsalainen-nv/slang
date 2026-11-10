//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#linkage-and-lifetime
//META: purpose=Every user-declared top-level function carries an export decoration whose operand is its mangled linkage name.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `export` records the mangled linkage name of a top-level
// declaration. The CHECK matches an `[export("...")]` line containing the
// source identifier and then the `func %triple` it precedes, which shows
// the decoration is attached to the function inst rather than emitted
// standalone. The mangled prefix/suffix are wildcarded because they encode
// the module name and signature.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

int triple(int x) { return x + x + x; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = triple(int(tid.x));
}

// CHECK: [export("{{.*}}triple{{.*}}")]
// CHECK: func %triple
