//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=A name inside a NamespaceDecl scope is reachable via explicit `Namespace::name` qualification.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Positive companion to namespace-member-needs-qualification: the
// same `inner::answer` is reachable with explicit qualification.

//TEST:INTERPRET(filecheck=CHECK):

namespace inner {
    int answer() { return 7; }
}

void main()
{
    int q = inner::answer();
    // CHECK: q=7
    printf("q=%d\n", q);
}
