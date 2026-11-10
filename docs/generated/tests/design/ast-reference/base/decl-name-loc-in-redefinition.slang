//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/base.md#decl-declbase
//META: purpose=A Decl's nameAndLoc pairs the declared name with the source location of the name token, so a conflicting-declaration diagnostic points at the name column rather than at the start of the declaration.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the location a Decl stores is the location of the
// declared *name*, not of the whole declaration. Two module-scope
// variables share the spelling `dup`; the checker rejects the second
// one. The caret annotation sits under `dup` (column 7), several
// columns past the start of the `float` declaration, and the note
// points at the first declaration's own name column.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

int dup;
/*CHECK:
    ^^^ see previous declaration of 'dup'
*/
float dup;
/*CHECK:
      ^^^ conflicting declaration
      ^^^ declaration of 'dup' conflicts with existing declaration
*/
// CHECK: E30200

void main() {}
