//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operator-precedence.md#operator-precedence
//META: purpose=Level-3 `*`/`/`/`%` are left-associative: `16 / 4 / 2` groups as `(16/4)/2` = 2, not `16/(4/2)` = 8.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The precedence table says `*`/`/`/`%` at level 3 have left associativity.
// Left assoc: `a / b / c` = `(a/b)/c`.
// If right-associative, `16 / 4 / 2` would be `16 / (4/2)` = `16/2` = 8.
// The correct left-associative result is `(16/4)/2` = `4/2` = 2.

//TEST:INTERPRET(filecheck=CHECK):

int div3(int a, int b, int c) { return a / b / c; }

void main()
{
    int result = div3(16, 4, 2);
    // CHECK: mul-left-assoc: 2
    printf("mul-left-assoc: %d\n", result);
}
