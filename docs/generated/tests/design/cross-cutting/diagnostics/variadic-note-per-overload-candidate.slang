//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#anatomy-of-a-diagnostic-entry
//META: purpose=A `variadic_note` on an entry renders one note record per supplied item, one `candidate:` note per overload candidate.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the variadic-note form of an entry expands to one rendered note
// per item rather than a single joined note. An ambiguous call to a two-candidate
// overload set is compiled; CHECK-DAG asserts a separate `candidate:` note naming
// each of the two signatures, which only happens if the variadic list is expanded
// at render time.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> buf;

int pick(int a, float b) { return 0; }
int pick(float a, int b) { return 1; }

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = pick(1, 1);
}

// CHECK-DAG: ambiguous call to 'pick'
// CHECK-DAG: candidate: func pick(int, float)
// CHECK-DAG: candidate: func pick(float, int)
