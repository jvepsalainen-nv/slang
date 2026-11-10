//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#sibling-scopes
//META: purpose=When a module is imported, the checker adds its scope as a sibling so names from it are reachable without explicit qualification; the core module's builtins (e.g. `sin`) are reachable through this mechanism.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Sibling scopes use case 2 (imported modules): when module B
// imports module A, A's scope is linked as a sibling of B's so
// unqualified names resolve. The core module is implicitly available
// to every translation unit; `sin` resolves without explicit
// `core::sin` qualification.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    float v = sin(0.0);
    // CHECK: ok
    printf("ok\n");
}
