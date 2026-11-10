//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#enumdecl-and-enumcasedecl
//META: purpose=An enum case carries a tag expression and value, not a variant payload; a payload-style case is a parse error.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that enum cases are tag-carrying, not payload-carrying. Writing a
// case with a parenthesized payload type is rejected during parsing; the
// CHECK pins the unexpected-token error (E20001) at the case, which is the
// user-visible consequence of a case having no payload slot.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

enum E { A(int) }
//CHECK: E20001

void main() {}
