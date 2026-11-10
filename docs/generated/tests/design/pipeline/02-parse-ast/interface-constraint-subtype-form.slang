//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#interface-associated-type-and-__constraint-requirements
//META: purpose=The `__constraint Subject : IBound` subtype form parses into a subtype requirement on an inherited associated type.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `:` (subtype) arm of __constraint parsing, as opposed
// to the `==` equality arm. A derived interface constrains the base's
// associated type to conform to another interface; generic code
// bounded by the derived interface calls that interface's method on
// the associated-type value.

//TEST:INTERPRET(filecheck=CHECK):

interface ICounter
{
    int count();
}

interface IBase
{
    associatedtype DataType;
    DataType getData();
}

interface IDerived : IBase
{
    __constraint DataType : ICounter;
}

struct Item : ICounter
{
    int n;
    int count() { return n; }
}

struct Holder : IDerived
{
    typealias DataType = Item;
    Item item;
    Item getData() { return item; }
}

int useSubtype<T : IDerived>(T x)
{
    return x.getData().count();
}

void main()
{
    Holder h;
    h.item.n = 33;
    // CHECK: count=33
    printf("count=%d\n", useSubtype(h));
}
