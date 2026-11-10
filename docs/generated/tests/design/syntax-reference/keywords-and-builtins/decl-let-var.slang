//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=`let` introduces an immutable binding and `var` introduces a mutable binding; both are decl keywords.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Declare both a `let` and a `var` of the same value, mutate the
// `var` once, and observe the result. The mutability difference is
// covered by a separate diagnostic test.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    let a = 7;
    var b = 5;
    b = b + 1;
    // CHECK: a=7 b=6
    printf("a=%d b=%d\n", a, b);
}
