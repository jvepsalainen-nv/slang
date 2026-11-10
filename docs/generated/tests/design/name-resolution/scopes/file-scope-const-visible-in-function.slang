//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=ModuleDecl/FileDecl members are reachable from any function in the file via the parent-scope walk.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// ModuleDecl is listed as scope-bearing. A file-scope const declared
// in the module is reachable from a function body via the parent
// chain (function scope -> file/module scope).

//TEST:INTERPRET(filecheck=CHECK):

static const int kAnswer = 42;

void main()
{
    // CHECK: kAnswer=42
    printf("kAnswer=%d\n", kAnswer);
}
