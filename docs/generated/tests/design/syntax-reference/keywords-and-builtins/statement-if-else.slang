//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#statement-keywords
//META: purpose=`if` and `else` are statement keywords recognized by direct identifier comparison in the statement parser; the conditional branches according to the boolean argument.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `if (cond) { ... } else { ... }` is accepted by the
// parser and that the `else` clause is reached when the condition is
// false. Both arms write the same variable, so a parser that silently
// dropped the `else` clause would still leave the variable at its
// initial value.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 0;
    if (false) { x = 7; } else { x = 9; }
    // CHECK: x=9
    printf("x=%d\n", x);
}
