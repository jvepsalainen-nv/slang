//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#compiletimeforstmt
//META: purpose=From language version 202c on, the compile-time `for` is reported as the error E30526 (removed from the language) while the node is still built.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `$for` removal error: under `-std 202c` the same loop is
// rejected with E30526.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry computeMain -stage compute -std 202c

RWStructuredBuffer<int> outputBuffer;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    int s = 0;
    $for(i in Range(3)) { s += i; }
/*CHECK:
     ^^^ compile-time for has been removed
     ^^^ compile-time for has been removed from the language. Use '[ForceUnroll] for' instead.
*/
    outputBuffer[0] = s;
}
