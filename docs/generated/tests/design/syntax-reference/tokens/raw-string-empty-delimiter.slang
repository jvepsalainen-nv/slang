//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#special-case-lexing-rules
//META: purpose=Boundary - a raw string with an empty delimiter (`R"(...)"`) lexes correctly, terminating only at `)"`.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: the documented raw-string syntax `R"delimiter(...)delimiter"`
// permits an empty delimiter. The content `hello` here must reach
// emitted CPP intact.

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    printf("%s\n", R"(hello)");
    //CHECK: "hello"
}
