//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#attributes-and-decorations
//META: purpose=`Attribute` parses as `'[' AttributeBody ']'` where `AttributeBody` is `AttributeName '(' ArgList ')'`, and attaches to the following decl.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the bracket-form attribute production. `[numthreads(1,1,1)]`
// is an `AttributeName` followed by an `ArgList` inside parens, inside
// square brackets, attached to the entry-point function.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -stage compute -entry main

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    // CHECK: numthreads
}
