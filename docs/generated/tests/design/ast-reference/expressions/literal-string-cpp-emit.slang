//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=A StringLiteralExpr carries the parsed string value; the same string text appears in emitted C++ output.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// slangi printf does not support %s, so for StringLiteralExpr value
// observation we compile to C++ and FileCheck the emitted source.
// The literal "agentic-string-marker" must appear verbatim.

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    printf("agentic-string-marker");
    // CHECK: agentic-string-marker
}
