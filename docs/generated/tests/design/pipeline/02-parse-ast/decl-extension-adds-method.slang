//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#the-major-node-families
//META: purpose=`extension <Type> { ... }` parses into an ExtensionDecl whose members become callable on the target type.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Add a `totalCents` method to `Wallet` via an `extension` block. The
// call `w.totalCents()` resolves only if the extension parsed and
// attached the method to the type.

//TEST:INTERPRET(filecheck=CHECK):

struct Wallet { int dollars; };

extension Wallet
{
    int totalCents() { return dollars * 100; }
};

void main()
{
    Wallet w;
    w.dollars = 5;
    // CHECK: c=500
    printf("c=%d\n", w.totalCents());
}
