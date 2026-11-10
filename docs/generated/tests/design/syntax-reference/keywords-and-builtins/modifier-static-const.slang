//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#simple-modifiers
//META: purpose=`static` and `const` are simple modifiers; a `static const` file-scope binding is a compile-time-known value the parser accepts and the checker treats as read-only.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `static const int K = 13;` at file scope is the canonical
// compile-time-known-value pattern. Reading it from `main` exercises
// both modifiers on a single declaration.

//TEST:INTERPRET(filecheck=CHECK):

static const int K = 13;

void main()
{
    // CHECK: K=13
    printf("K=%d\n", K);
}
