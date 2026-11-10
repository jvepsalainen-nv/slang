//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#castoptionalexpr
//META: purpose=An Optional<T> value used where an Optional<U> is wanted is coerced whenever the bare T-to-U conversion would be accepted, which covers both a numeric widening and an up-cast to an interface.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the optional-to-optional coercion follows the inner
// conversion rather than requiring the two element types to match. Three
// shapes exercise it: an assignment (`Optional<int>` into an
// `Optional<float>` variable), an argument (`Optional<int>` passed where
// `Optional<float>` is declared), and an up-cast to an interface
// (`Optional<Square>` passed where `Optional<IShape>` is declared). The CHECK
// reads a value back through each, so a coercion that dropped the payload or
// lost the conformance would change the printed numbers rather than silently
// pass.

//TEST:INTERPRET(filecheck=CHECK):

interface IShape
{
    int sides();
}

struct Square : IShape
{
    int sides() { return 4; }
}

int takeOptionalFloat(Optional<float> v)
{
    return v.hasValue ? int(v.value * 10.0) : -1;
}

int takeOptionalShape(Optional<IShape> v)
{
    return v.hasValue ? v.value.sides() : -1;
}

void main()
{
    Optional<int> oi = 3;
    Optional<float> of = oi;
    Optional<Square> os = Square();

    printf("assign=%d arg=%d iface=%d\n", int(of.value), takeOptionalFloat(oi), takeOptionalShape(os));
}

//CHECK: assign=3 arg=30 iface=4
