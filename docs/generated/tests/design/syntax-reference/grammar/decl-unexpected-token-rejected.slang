//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#declarations
//META: purpose=A token that cannot begin a `Decl` triggers a parse-stage diagnostic.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the parser rejects an ill-formed top-level construct.
// `@` is not a valid start-of-decl token, so the parser emits a
// diagnostic when it encounters it.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

@ int x = 1;
/*CHECK:
^ unexpected token
^ unexpected '@', expected identifier
      ^ unexpected token
      ^ unexpected identifier, expected ';'
        ^ unexpected token
        ^ unexpected '=', expected identifier
*/

void main()
{
}
