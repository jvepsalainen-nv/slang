//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operators.md#conditional-expression
//META: purpose=The conditional operator `?:` does NOT short-circuit per the explicit doc note "Slang currently follows the precedent of HLSL where `?:` does not short-circuit." Both branches are evaluated.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc's note is unambiguous: Slang's `?:` evaluates both
// branches even though only one value is yielded. Verify by placing
// a side-effecting bump on each branch and asserting the counter
// reflects BOTH bumps, not just the selected one.
//
// If the compiler accidentally implements C-family short-circuit
// `?:`, this test catches it.

//TEST:INTERPRET(filecheck=CHECK):

int bump(inout int counter) { counter++; return counter; }

void main()
{
    int counter = 0;
    bool cond = true;
    int picked = cond ? bump(counter) : bump(counter);
    //CHECK: counter=2
    printf("counter=%d\n", counter);
}
