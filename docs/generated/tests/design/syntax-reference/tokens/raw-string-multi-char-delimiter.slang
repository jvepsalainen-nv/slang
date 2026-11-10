//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#special-case-lexing-rules
//META: purpose=Boundary - a multi-character delimiter (`long`) on a raw string opens with `R"long(` and closes only at `)long"`.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: the documented raw-string rule uses an "arbitrary"
// delimiter. A four-character delimiter is exercised here. The string
// content includes a `)` and a `)w` substring that resemble a close
// for shorter delimiters but must NOT terminate this token.

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    printf("%s\n", R"long(a)b)wc)long");
    //CHECK: "a)b)wc"
}
