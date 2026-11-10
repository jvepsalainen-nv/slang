//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#per-keyword-semantics
//META: purpose=A `public` decl is always visible; `isDeclVisibleFromScope` short-circuits on Public and returns true.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-keyword semantics: `public` is universally visible. The
// predicate's first branch returns true unconditionally.

//TEST:INTERPRET(filecheck=CHECK):

public int exposed() { return 7; }

void main()
{
    // CHECK: exposed=7
    printf("exposed=%d\n", exposed());
}
