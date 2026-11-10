//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#modifier-parsing
//META: purpose=The parser attaches an attribute wherever modifier parsing runs and leaves the question of which declarations it may modify to semantic checking, which reports an invalid placement.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the division of labour between the two stages. `[unroll]` is a loop
// attribute, but here it is written in front of a function declaration. The
// parser raises no complaint — there is no syntax error and no unexpected-token
// report — and the only diagnostic is the placement error the checker raises
// once it knows what kind of declaration the modifier landed on. Exhaustive
// mode makes the absence of a parse-stage diagnostic part of the assertion.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

[unroll]
/*CHECK:
 ^^^^^^ error E31002
 ^^^^^^ attribute 'unroll' is not valid here
*/
void main()
{
}
