//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=An ImportDecl naming a module that cannot be found on the search path is diagnosed.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an import is resolved against real files rather than recorded
// as an unchecked name. The imported module does not exist; the CHECK pins the
// file-not-found diagnostic under the module name.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

import this_module_does_not_exist_zzz;
/*CHECK:
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ cannot open file 'this_module_does_not_exist_zzz.slang'
*/

void main() {}
