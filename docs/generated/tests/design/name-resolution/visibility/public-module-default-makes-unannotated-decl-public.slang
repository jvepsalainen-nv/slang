//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#defaults-by-language-version
//META: purpose=A `public` modifier on the module declaration flips the module-wide default so unannotated decls are `public` instead of `internal`.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `public module ...;` changes `ModuleDecl::defaultVisibility`.
// `Unannotated` carries no visibility modifier, and a `public` function names
// it in its signature. With the ordinary `internal` module default that is a
// less-visible-type rejection (E30604); with the flipped `public` default it
// checks cleanly. The CHECK asserts the program ran and returned the field
// read through the public signature.

//TEST:INTERPRET(filecheck=CHECK):

public module publicModuleDefault;

struct Unannotated { int v; }

public int use(Unannotated u) { return u.v; }

void main()
{
    Unannotated u;
    u.v = 5;
    // CHECK: v=5
    printf("v=%d\n", use(u));
}
