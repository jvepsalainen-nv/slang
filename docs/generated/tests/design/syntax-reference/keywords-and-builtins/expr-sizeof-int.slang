//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#expression-keywords
//META: purpose=`sizeof` is an expression keyword that returns the size, in bytes, of its type operand at compile time.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `sizeof(int)` should resolve to 4 in the Slang core-module type
// system. The constructor-style cast `int(sizeof(int))` avoids the
// C-style cast that the pilot bundle reported as unreliable in the
// interpreter.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    // CHECK: s=4
    printf("s=%d\n", int(sizeof(int)));
}
