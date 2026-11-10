//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#enumdecl-and-enumcasedecl
//META: purpose=An EnumCaseDecl carries the case's tag value; converting the case to its underlying integer yields exactly that value.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an enum case stores the tag value written after `=` rather
// than an ordinal position. The cases use non-consecutive tags (1, 5, 9) and
// the CHECK asserts the converted integers are those tags, which would print
// 0 1 2 if positions were used instead.

//TEST:INTERPRET(filecheck=CHECK):

enum E { A = 1, B = 5, C = 9 }

void main()
{
    //CHECK: 1 5 9
    printf("%d %d %d\n", int(E::A), int(E::B), int(E::C));
}
