//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#extensions
//META: purpose=An extension with an inheritance clause introduces a new conformance; the extended type then satisfies the interface and can be used where the interface is required.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an extension with an inheritance clause adds a new interface conformance.
// `MyVec` gains `IPrintable` through an extension; passing it to the generic `print<T : IPrintable>`
// and checking the output "(1, 2)" proves the conformance is resolved at the call site.

//TEST:INTERPRET(filecheck=CHECK):

interface IPrintable { void printSelf(); }

struct MyVec { float x, y; }

extension MyVec : IPrintable
{
    void printSelf() { printf("(%g, %g)\n", x, y); }
}

void print<T : IPrintable>(T v) { v.printSelf(); }

void main()
{
    MyVec v;
    v.x = 1.0;
    v.y = 2.0;
    // CHECK: (1, 2)
    print(v);
}
