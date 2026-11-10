//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#aggtypedecl-structdecl-classdecl-enumdecl
//META: purpose=A StructDecl can nest another StructDecl as a member; the nested type is reachable through dotted member access.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the shared container behaviour of aggregate declarations
// extends to nesting: a struct may declare a field of another struct type,
// and member access chains through it. The CHECK asserts a sum computed
// from both the nested field and a sibling field.

//TEST:INTERPRET(filecheck=CHECK):

struct Inner { int v; }
struct Outer { Inner inner; int extra; }

void main()
{
    Outer o;
    o.inner.v = 30;
    o.extra = 5;
    //CHECK: 35
    printf("%d\n", o.inner.v + o.extra);
}
