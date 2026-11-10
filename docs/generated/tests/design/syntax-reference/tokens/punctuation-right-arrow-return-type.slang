//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#punctuation-and-structural-symbols
//META: purpose=The two-character spelling `->` lexes as a single `RightArrow` token, which introduces a function's return type.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `->` is one token and not `OpSub` followed by `OpGreater`. In the
// `func` declaration form the arrow is the only thing that can introduce the
// return type, so a split into minus-plus-greater-than could not parse. Calling
// the function and printing its result proves the declaration was accepted.

//TEST:INTERPRET(filecheck=CHECK):

func addOne(x: int) -> int
{
    return x + 1;
}

void main()
{
    // CHECK: arrow=42
    printf("arrow=%d\n", addOne(41));
}
