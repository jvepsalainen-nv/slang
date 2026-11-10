//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#interface-associated-type-and-__constraint-requirements
//META: purpose=The `__constraint DataType == This` equality form inside a derived interface parses and lets generic code treat the inherited associated type as the conforming type itself.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's own `__constraint DataType == This` example. The
// derived interface pins the base's associated type to the conformer,
// so a generic bounded by IDerived can call an IDerived method on
// `getData()`'s result — legal only if the equality constraint parsed
// with isEqualityConstraint semantics.

//TEST:INTERPRET(filecheck=CHECK):

interface IBase
{
    associatedtype DataType;
    DataType getData();
}

interface IDerived : IBase
{
    __constraint DataType == This;
    int value();
}

struct Node : IDerived
{
    typealias DataType = Node;
    int v;
    Node getData() { return this; }
    int value() { return v; }
}

int useEquality<T : IDerived>(T x)
{
    // x.getData() has type T.DataType == T, so value() is callable on it.
    return x.getData().value();
}

void main()
{
    Node n;
    n.v = 27;
    // CHECK: value=27
    printf("value=%d\n", useEquality(n));
}
