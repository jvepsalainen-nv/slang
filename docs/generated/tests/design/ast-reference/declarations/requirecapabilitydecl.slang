//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A RequireCapabilityDecl (`__require_capability`) is a module-scope declaration; a module requiring a capability the target provides still compiles.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a capability requirement is expressed as a declaration and is
// satisfied when the target provides the named capability. The module requires
// `cpp` and is run on the interpreter's CPU-backed path; the CHECK asserts the
// program's output, which only appears if the requirement was accepted.

//TEST:INTERPRET(filecheck=CHECK):

__require_capability cpp;

void main()
{
    //CHECK: ok
    printf("ok\n");
}
