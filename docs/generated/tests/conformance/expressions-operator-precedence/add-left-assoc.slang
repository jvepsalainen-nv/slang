//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operator-precedence.md#operator-precedence
//META: purpose=Level-4 `+`/`-` are left-associative: `10 - 3 - 2` groups as `(10-3)-2` = 5, not `10-(3-2)` = 9.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The precedence table says `+`/`-` at level 4 have left associativity.
// Left assoc: `a - b - c` = `(a-b)-c`.
// If right-associative, `10 - 3 - 2` would be `10 - (3-2)` = 9.
// The correct left-associative result is `(10-3)-2` = 5.

//TEST:INTERPRET(filecheck=CHECK):

int sub3(int a, int b, int c) { return a - b - c; }

void main()
{
    int result = sub3(10, 3, 2);
    // CHECK: add-left-assoc: 5
    printf("add-left-assoc: %d\n", result);
}
