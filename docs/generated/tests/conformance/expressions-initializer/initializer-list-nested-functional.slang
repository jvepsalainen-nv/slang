//META: generated=true
//META: doc_ref=docs/language-reference/expressions-initializer.md#initializer-list-expression
//META: purpose=Nested initializer lists ({ {a,b}, {c,d} }) initialize nested struct fields in declaration order.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that initializer list elements may themselves be initializer lists,
// enabling nested struct initialization. `{ {1,2}, {3,4} }` must populate the
// `first` and `second` fields of `Outer` in declaration order. CHECK asserts
// all four inner field values match the positions in the nested literal.

//TEST:INTERPRET(filecheck=CHECK):

struct Inner { int a; int b; };
struct Outer { Inner first; Inner second; };

int passInt(int v) { return v; }

void main()
{
    Outer o = { { passInt(1), passInt(2) }, { passInt(3), passInt(4) } };
    //CHECK: 1 2 3 4
    printf("%d %d %d %d\n", o.first.a, o.first.b, o.second.a, o.second.b);
}
