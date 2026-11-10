//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=Adjacent string literals merge during expression parsing into a single StringLiteralExpr; the concatenated text appears as one literal in emitted C++.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that two adjacent string-literal tokens merge into one string
// value during expression parsing. The printf argument is written as two
// juxtaposed literals; CHECK matches the concatenation as one contiguous
// run of text in the emitted C++, which cannot match if the two pieces
// stayed separate quoted literals.

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    printf("agentic-merge-head-" "agentic-merge-tail");
    // CHECK: agentic-merge-head-agentic-merge-tail
}
