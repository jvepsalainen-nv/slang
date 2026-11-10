//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#content-tokens
//META: purpose=Boundary - the empty StringLiteral (`""`) is a valid token whose content is zero characters.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: zero-length string literal must lex cleanly and
// survive through to emitted C++ source as `""`.

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    printf("%s\n", "");
    //CHECK: printf({{.*}}"%s{{.*}}", "")
}
