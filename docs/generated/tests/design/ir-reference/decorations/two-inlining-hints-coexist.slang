//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#inlining-and-optimization
//META: purpose=Two helper functions with opposing inlining hints ([ForceInline] vs [noinline]) each surface their own decoration, independent of the other.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the inlining decorations are per-function properties rather
// than a module-wide policy. Two helpers with opposite hints are called
// from the same entry point and the CHECK-DAG lines assert both decorations
// coexist, which a shared or last-one-wins representation could not
// satisfy.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[ForceInline]
int hot(int x) { return x + 1; }

[noinline]
int cold(int x) { return x * 2; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = hot(int(tid.x)) + cold(int(tid.x));
}

// CHECK-DAG: [ForceInline]
// CHECK-DAG: [noInline]
