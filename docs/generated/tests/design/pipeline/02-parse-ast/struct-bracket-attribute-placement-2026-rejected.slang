//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#modifier-parsing
//META: purpose=From language version 2026 on, a bracketed attribute list written after the `struct` keyword is rejected outright with E31205.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the newest arm of the placement gate: the same declaration that is
// silent at 2018 and a warning at 2025 is an error at 2026. Because the parser
// still parses the attribute list before judging where it sits, the complaint
// is about placement rather than about unexpected tokens — which is what
// separates this rule from an ordinary syntax error, and why the whole thing is
// decided by the module's language version rather than by the grammar.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-std 2026

struct [__NonCopyableType] Foo { int x; };
/*CHECK:
       ^ error E31205
       ^ invalid placement of bracketed attributes list.
*/

void main()
{
    Foo f;
    f.x = 1;
    printf("v=%d\n", f.x);
}
