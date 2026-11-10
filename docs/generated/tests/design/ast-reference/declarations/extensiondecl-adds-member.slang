//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#extensiondecl
//META: purpose=An ExtensionDecl attaches new members to an existing type; the added member is callable on values of that type.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that members written inside `extension T { ... }` become members of
// `T` after name lookup resolves the extension's target type. The struct
// itself declares no method; the CHECK asserts the extension method's result,
// which is only reachable if the attachment happened.

//TEST:INTERPRET(filecheck=CHECK):

struct Counter { int v; }

extension Counter
{
    int doubled() { return v * 2; }
}

void main()
{
    Counter c; c.v = 21;
    //CHECK: 42
    printf("%d\n", c.doubled());
}
