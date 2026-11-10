//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#user-defined-syntax
//META: purpose=`RequireCapabilityDecl` parses as `'__require_capability' CapabilityName ';'` with no parentheses around the name.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the module-scope capability declaration takes a bare
// capability atom terminated by `;` — no parentheses, unlike the
// statement-level `__requireCapability(...)` spelling. The declaration
// sits before the entry point, so if the parser stopped short of the
// `;` the following function would not be reached; the CHECK on the
// emitted HLSL entry point is what proves the whole file parsed.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -stage compute -entry computeMain

__require_capability sm_5_0;

RWStructuredBuffer<int> outputBuffer;

// CHECK: void computeMain()
[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = 7;
}
