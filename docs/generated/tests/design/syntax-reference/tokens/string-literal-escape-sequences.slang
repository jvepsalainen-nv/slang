//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#content-tokens
//META: purpose=Boundary - escape sequences (`\t`, `\n`, `\\`, `\"`) inside a regular StringLiteral are accepted by the lexer and round-trip through to emitted C++.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: the four common escape sequences must lex inside
// a double-quoted string. The emitted CPP keeps the escapes literal
// (the lexer does not yet decode them — that happens later).

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    printf("%s\n", "a\tb\nc\\d\"e");
    //CHECK: "a\tb\nc\\d\"e"
}
