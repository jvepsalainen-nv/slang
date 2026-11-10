//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#partiallyappliedgenericexpr
//META: purpose=A PartiallyAppliedGenericExpr provides some generic arguments and lets overload resolution infer the rest from call-site argument types.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that supplying only some of a generic's parameters still yields a
// callable whose remaining parameters are inferred from the call arguments.
// `pair<int>` fixes T; U is deduced from the float argument, and the CHECKs
// read both components back to prove each parameter bound as intended.

//TEST:INTERPRET(filecheck=CHECK):

struct Pair<T, U> { T first; U second; }

Pair<T, U> pair<T, U>(T a, U b)
{
    Pair<T, U> p;
    p.first = a;
    p.second = b;
    return p;
}

void main()
{
    // Only T is explicitly provided; U is inferred from the float arg.
    Pair<int, float> p = pair<int>(7, 1.5f);
    // CHECK: first=7
    printf("first=%d\n", p.first);
    // CHECK: second=1
    printf("second=%d\n", int(p.second));
}
