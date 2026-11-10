//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#nodes
//META: purpose=A type expression used in value position has the type *of* a type (its kind), which the checker renders as `typeof(T)` when it does not match the expected value type.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that naming a type where a value is expected does not simply
// fail as an undefined name: the type expression is checked and carries
// a type-of-a-type, which the mismatch diagnostic renders. CHECK pins
// `got 'typeof(float)'`, which is only printable if the type expression
// had a type of its own.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    int x = float;
//CHECK:    ^^^^^ type mismatch in expression
//CHECK:    ^^^^^ expected an expression of type 'int', got 'typeof(float)'
    printf("x=%d\n", x);
}
