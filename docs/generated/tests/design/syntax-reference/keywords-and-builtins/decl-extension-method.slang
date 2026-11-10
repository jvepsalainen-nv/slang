//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=`extension <Type> { ... }` is a decl keyword that adds new members to an existing type without modifying its primary declaration.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Add a `sum()` method to `Vec2` via an `extension` block and verify
// the new method is callable through normal member-access syntax.

//TEST:INTERPRET(filecheck=CHECK):

struct Vec2 { int x; int y; };

extension Vec2
{
    int sum() { return x + y; }
}

void main()
{
    Vec2 v;
    v.x = 3;
    v.y = 4;
    // CHECK: s=7
    printf("s=%d\n", v.sum());
}
