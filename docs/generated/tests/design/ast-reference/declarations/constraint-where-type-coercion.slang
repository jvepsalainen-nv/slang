//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#generictypeconstraintdecl-as-an-interface-requirement
//META: purpose=A `where To(From) implicit` clause is a coercion constraint that lets a call site convert the argument to the type parameter.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the coercion spelling of a `where` clause, including the trailing
// `implicit` keyword. The generic is explicitly specialized at a struct while
// the argument is an `int`; only the coercion constraint makes that call
// legal, and the CHECK asserts the value the struct's converting constructor
// stored.

//TEST:INTERPRET(filecheck=CHECK):

interface IHasValue { int getValue(); }

struct V : IHasValue
{
    int value;
    __implicit_conversion(100)
    __init(int v) { value = v; }
    int getValue() { return value; }
}

int readValue<T>(T x) where T(int) implicit where T : IHasValue
{
    return x.getValue();
}

void main()
{
    //CHECK: 41
    printf("%d\n", readValue<V>(41));
}
