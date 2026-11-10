//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#astypeexpr--istypeexpr--casttosupertypeexpr
//META: purpose=An AsTypeExpr `value as Type` yields an Optional<Type> populated when the dynamic type matches; the value is recoverable.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// AsTypeExpr is documented as a subtype cast carrying a witnessArg.
// In Slang, `value as Type` yields `Optional<Type>`; calling
// `.value` on the Optional after `.hasValue` reads the recovered
// concrete value.

//TEST:INTERPRET(filecheck=CHECK):

interface IShape { int area(); }
struct Sq : IShape { int s; int area() { return s * s; } }

int describe(IShape shape)
{
    if (shape is Sq)
    {
        Optional<Sq> opt = shape as Sq;
        if (opt.hasValue) return opt.value.area();
    }
    return -1;
}

void main()
{
    Sq sq = {4};
    // CHECK: a=16
    printf("a=%d\n", describe(sq));
}
