//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=`func name(params) -> RetType { ... }` is the Slang-style function-decl form introduced by the `func` decl keyword.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Use the `func ... -> T` form (as opposed to the C-style
// `T name(...)` form) and observe the resulting function dispatches
// normally. Both `func` and the right-arrow trivia token are part of
// this decl form.

//TEST:INTERPRET(filecheck=CHECK):

func answer() -> int { return 42; }

void main()
{
    // CHECK: a=42
    printf("a=%d\n", answer());
}
