//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#where-visibility-is-filtered
//META: purpose=`isDeclVisibleFromScope` treats an extension on the same type as inside the aggregate; a private member is reachable from that extension.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The predicate `isDeclVisibleFromScope` resolves the requesting
// scope's enclosing aggregate, including extensions whose target
// type matches. A private struct member is therefore reachable from
// a method defined in `extension S { ... }`.

//TEST:INTERPRET(filecheck=CHECK):

struct S
{
    private int secret;
    __init(int x) { secret = x; }
}

extension S
{
    int viaExtension() { return secret + 1; }
}

void main()
{
    S s = S(10);
    // CHECK: viaExtension=11
    printf("viaExtension=%d\n", s.viaExtension());
}
