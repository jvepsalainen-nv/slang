//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#genericdecl
//META: purpose=A GenericDecl wraps an inner declaration with a parameter list, so one written function serves several specializations.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a single generic function declaration is usable at more than
// one type argument. The same declaration is called explicitly at `int` and at
// `float`; the CHECK asserts both results, which requires the parameter list
// on the wrapper to feed the one inner function declaration.

//TEST:INTERPRET(filecheck=CHECK):

T pickFirst<T>(T a, T b) { return a; }

void main()
{
    //CHECK: 7 2.500000
    printf("%d %f\n", pickFirst<int>(7, 8), pickFirst<float>(2.5f, 9.0f));
}
