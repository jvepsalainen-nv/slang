//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#function-style-declarations
//META: purpose=`Param` accepts the modern name-first form `IDENT ':' Type ('=' Expr)?` with a default-value clause.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the modern (name-first) parameter production including its
// default-value clause: `factor : int = 2`. Calling with and without
// the second argument yields different products, proving the default
// clause parsed and applies only when the argument is omitted.

//TEST:INTERPRET(filecheck=CHECK):

func scale(x : int, factor : int = 2) -> int
{
    return x * factor;
}

void main()
{
    // CHECK: a=42
    printf("a=%d\n", scale(21));
    // CHECK: b=63
    printf("b=%d\n", scale(21, 3));
}
