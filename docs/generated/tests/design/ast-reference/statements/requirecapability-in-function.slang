//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#requirecapabilitystmt
//META: purpose=A RequireCapabilityStmt is a statement-level capability assertion (`__requireCapability(...)`) scoped to the enclosing function; the function compiles when the target capability set satisfies the listed atoms.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the statement spelling of `__requireCapability` is accepted
// inside a function body and resolves the named atom against the
// compilation target. Compiling for HLSL while requiring `hlsl` must
// succeed; the CHECK asserts the enclosing code was emitted.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry computeMain -stage compute

void helper()
{
    __requireCapability(hlsl);
}

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain()
{
    helper();
    //CHECK: void
}
