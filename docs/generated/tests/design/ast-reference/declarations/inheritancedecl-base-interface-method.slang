//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#inheritancedecl
//META: purpose=The witness recorded on an inheritance clause is what connects a requirement to the conformer's member at each dispatch site.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the conformance recorded by an inheritance clause routes an
// interface requirement to the conformer's member. A struct with two fields
// implements the single requirement in terms of both; the CHECK asserts their
// product, which is only produced by the conformer's body being selected.

//TEST:INTERPRET(filecheck=CHECK):

interface IShape
{
    int area();
}

struct Rect : IShape
{
    int w; int h;
    int area() { return w * h; }
}

int areaOf<T : IShape>(T s) { return s.area(); }

void main()
{
    Rect r;
    r.w = 4; r.h = 5;
    //CHECK: 20
    printf("%d\n", areaOf(r));
}
