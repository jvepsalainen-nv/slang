//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#deferstmt
//META: purpose=The checker rejects a `return` inside a deferred statement with E30110.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `return` may not appear inside a `defer` statement.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry computeMain -stage compute

RWStructuredBuffer<int> outputBuffer;

int f(int x)
{
    defer { return 3; }
//CHECK:    ^^^^^^ 'return' inside defer
//CHECK:    ^^^^^^ 'return' must not appear inside a defer statement.
    return x;
}

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    outputBuffer[0] = f(1);
}
