//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=The dedicated ScopeDecl the parser pushes for a lambda parameter list makes the parameter visible in the lambda body, with the enclosing function scope still reachable as its parent.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies both halves of the lambda parameter scope: the parameter `p` is
// in scope inside the lambda body, and the parent link from that scope still
// reaches the enclosing function's local `c`. The lambda computes `p * c`,
// so a result of 15 for p=5 and c=3 can only be produced if both names bound
// — `p` from the pushed parameter scope and `c` from its parent. The lambda
// is passed through an IFunc-constrained helper because a directly invoked
// lambda does not execute on the interpreter.

//TEST:INTERPRET(filecheck=CHECK):

int applyF<F : IFunc<int, int>>(F f, int v)
{
    return f(v);
}

void main()
{
    int c = 3;
    int r = applyF((int p) => p * c, 5);
    // CHECK: r=15
    printf("r=%d\n", r);
}
