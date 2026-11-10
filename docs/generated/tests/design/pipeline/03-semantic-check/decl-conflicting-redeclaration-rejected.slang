//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#files-and-responsibilities
//META: purpose=Decl checking rejects two struct types declared with the same name as a conflicting declaration (E30200) and points at the previous declaration.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "Decl checking" concern by exercising its name-collision rule
// at the type-declaration shape. Two `struct Dup` definitions occupy the same
// container, so the second must be reported as conflicting; CHECK pins E30200
// on the second name and the companion note that names the first.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct Dup { int a; }

struct Dup { int b; }
//CHECK: E30200
//CHECK: see previous declaration of 'Dup'

void main()
{
}
