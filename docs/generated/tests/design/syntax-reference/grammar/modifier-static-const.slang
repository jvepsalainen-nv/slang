//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#modifiers
//META: purpose=`ModifierList` accepts multiple `ModifierKeyword` tokens (`static`, `const`) in sequence before a `VarDecl`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the parser collects a `ModifierList` of two
// ModifierKeywords (`static const`) attached to the file-scope
// `VarDecl`. The bound value is then read inside `main`.

//TEST:INTERPRET(filecheck=CHECK):

static const int kAnswer = 42;

void main()
{
    // CHECK: kAnswer=42
    printf("kAnswer=%d\n", kAnswer);
}
