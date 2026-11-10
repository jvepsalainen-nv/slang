//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#content-tokens
//META: purpose=A double-quoted `StringLiteral` is recognized by the lexer and its text content survives end-to-end through to emitted code.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies a plain double-quoted string literal is accepted by the
// lexer and emitted verbatim into CPP target output. The CHECK pattern
// looks for the literal text in the emitted CPP source.

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    printf("%s\n", "hello-world");
    //CHECK: "hello-world"
}
