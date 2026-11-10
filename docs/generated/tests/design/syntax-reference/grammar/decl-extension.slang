//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#type-defining-declarations
//META: purpose=`ExtensionDecl` parses as `'extension' Type '{' StructMember* '}'` and adds methods to an existing type.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the ExtensionDecl production: `extension Type { ... }` adds
// methods to an existing type. We extend a `struct Box` with a method
// and then call it from `main`.

//TEST:INTERPRET(filecheck=CHECK):

struct Box { int v; }

extension Box
{
    int doubled() { return v * 2; }
}

void main()
{
    Box b;
    b.v = 21;
    // CHECK: doubled=42
    printf("doubled=%d\n", b.doubled());
}
