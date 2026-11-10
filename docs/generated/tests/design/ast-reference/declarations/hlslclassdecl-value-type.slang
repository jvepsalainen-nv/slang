//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#aggtypedecl-structdecl-classdecl-enumdecl
//META: purpose=In HLSL source the `class` keyword produces an HLSLClassDecl, a value type that uses the struct grammar, so copying one leaves the original unchanged.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an HLSL-dialect `class` is a value type rather than a
// reference type. The program copies `a` into `b`, mutates the copy, and
// writes `a.v` to the buffer; the CHECK expects the store of the original
// value 1, which only holds under value semantics (a reference-type class
// would alias and store 2).

//TEST:SIMPLE_EX(filecheck=CHECK):-lang hlsl docs/generated/tests/design/ast-reference/declarations/hlslclassdecl-value-type.slang -target hlsl -entry main -stage compute

class P
{
    int v;
};

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    P a;
    a.v = 1;
    P b = a;
    b.v = 2;
    //CHECK: outBuf{{.*}}[{{.*}}] = {{.*}}1
    outBuf[0] = a.v;
}
