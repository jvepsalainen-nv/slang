//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#modifier-validation
//META: purpose=globallycoherent on a function parameter is the concrete pair that reaches E31201, while the same modifier on a struct field is accepted without -allow-glsl.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The non-GLSL arm for `GloballyCoherentModifier` requires `as<VarDecl>(decl)`,
// and a parameter is a `ParamDecl` -- a sibling of `VarDecl` under
// `VarDeclBase`, not a subclass -- so the predicate returns false and the
// modifier is rejected. The struct field below takes the *same* arm and is
// accepted, which is the half that shows `-allow-glsl` is not what admits it;
// exhaustive mode asserts the field draws no diagnostic.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

struct G { globallycoherent int a; }

void takesCoherent(globallycoherent int x) { }
/*CHECK:
                   ^^^^^^^^^^^^^^^^ error E31201
                   ^^^^^^^^^^^^^^^^ modifier 'globallycoherent' is not allowed here.
*/

RWStructuredBuffer<int> gOut;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    takesCoherent(1);
    gOut[0] = 1;
}
