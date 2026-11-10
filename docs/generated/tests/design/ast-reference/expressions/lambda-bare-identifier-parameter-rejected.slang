//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#lambdaexpr-and-lambdadecl
//META: purpose=A lambda is recognized only when a balanced parenthesized group is followed by the arrow, so there is no bare-identifier parameter form and x => x + 1 is a parse error at the arrow.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the parentheses are load-bearing rather than optional. The
// parser decides it is looking at a lambda by seeing a balanced parenthesized
// group in front of the arrow, so with a bare `x` the `x` is consumed as an
// ordinary expression and the arrow is left where a `;` was expected. CHECK
// pins E20001 at the arrow, which is what tells a reader the failure is the
// missing parentheses and not something about the body.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

int callWith(IFunc<int, int> f, int x)
{
    return f(x);
}

void main()
{
    let bare = x => x + 1;
//CHECK:         ^^ E20001
    printf("%d\n", callWith(bare, 5));
}
