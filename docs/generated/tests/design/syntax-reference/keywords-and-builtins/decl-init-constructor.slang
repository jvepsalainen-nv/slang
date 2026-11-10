//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=`__init` is the decl keyword for a constructor; it is invoked when the type name is used as a call expression.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Declare a struct with an `__init(int)` constructor and call it via
// the type-name-as-callable form `V(7)`. The doc notes that `__init`
// is the underscore-prefixed compiler-internal spelling of `init`.

//TEST:INTERPRET(filecheck=CHECK):

struct V
{
    int x;
    __init(int v) { x = v; }
}

void main()
{
    V v = V(7);
    // CHECK: x=7
    printf("x=%d\n", v.x);
}
