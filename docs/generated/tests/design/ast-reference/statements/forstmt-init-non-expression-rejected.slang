//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#loop-family
//META: purpose=A `for` header's initial position is parsed as a statement so that a declaration can introduce loop variables there, but only a declaration or an expression statement is accepted; anything else is diagnosed.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the initial position accepts a statement but restricts which
// kind. A block written there parses as a statement and is then
// rejected; the CHECK pins the E20001 diagnostic reported on that
// statement.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target cpp -entry computeMain -stage compute

RWStructuredBuffer<int> outputBuffer;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain()
{
    int n = 0;
    for ({ int i = 0; } n < 3; n = n + 1)
//CHECK:   ^^^ unexpected token
//CHECK:   ^^^ unexpected statement, expected expression
    {
    }
    outputBuffer[0] = n;
}
