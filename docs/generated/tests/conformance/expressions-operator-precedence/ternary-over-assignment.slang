//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operator-precedence.md#operator-precedence
//META: purpose=Level-13 `?:` binds more tightly than level-14 `=`: the doc example `a = b = c + d + e` shows `+` (level 4) and `=` (level 14) interacting with right-assoc; `=` is the loosest of all non-comma operators.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `+` (level 4) binds tighter than `=` (level 14) and that `=`
// is right-associative. `a = b = c + d + e` groups as `a = (b = ((c+d)+e))`.
// With c=1, d=2, e=3 the arithmetic completes first yielding 6, then both
// assignments propagate right-to-left, so CHECK asserts a=6 and b=6.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int a = 0;
    int b = 0;
    int c = 1, d = 2, e = 3;
    a = b = c + d + e;
    // CHECK: ternary-over-assign: a=6 b=6
    printf("ternary-over-assign: a=%d b=%d\n", a, b);
}
