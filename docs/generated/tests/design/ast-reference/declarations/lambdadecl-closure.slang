//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A lambda expression produces a callable closure declaration that an IFunc-constrained generic can invoke.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the checker turns a lambda expression into a callable value.
// The lambda is passed to a generic constrained on `IFunc`, which invokes it;
// the CHECK asserts the lambda body's result, so the closure must have been
// materialized as a conforming callable.

//TEST:INTERPRET(filecheck=CHECK):

TResult apply<TResult, TFunc:IFunc<TResult, int>>(TFunc f)
{
    return f(7);
}

void main()
{
    let r = apply( (int x) => x * 3 );
    //CHECK: 21
    printf("%d\n", r);
}
