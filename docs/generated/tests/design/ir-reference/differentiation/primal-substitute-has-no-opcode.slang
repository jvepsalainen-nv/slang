//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/differentiation.md#backwarddifferentiate
//META: purpose=[PrimalSubstitute] and [PrimalSubstituteOf] are AST-level attributes with no PrimalSubstitute opcode, so the substitute is resolved before lowering.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the carve-out the section makes alongside `__bwd_diff`: the
// primal-substitute attribute is resolved during checking and never becomes an
// inst. `myFunc` carries `[PrimalSubstitute(myFuncSubst)]`, so a naive lowering
// would need some inst to record "differentiate the substitute instead". The
// positive CHECK shows what happens instead — `myFunc` is annotated with a
// differentiation member drawn from `myFuncSubst`, i.e. the redirection is
// already baked into the annotation — while the two `CHECK-NOT`s bracket the
// whole LOWER-TO-IR section and require that no opcode spelled
// `PrimalSubstitute` exists anywhere in it. Without the positive CHECK the
// absence would be vacuous, since a program that ignored the attribute would
// also contain no such opcode.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform float a;
uniform float d;
uniform RWStructuredBuffer<float> buf;

[PrimalSubstitute(myFuncSubst)]
float myFunc(float x) { return x * x; }

[Differentiable]
float myFuncSubst(float x) { return x * x * x; }

[Differentiable]
float caller(float x) { return myFunc(x); }

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = __fwd_diff(caller)(DifferentialPair<float>(a, d)).d;
}

// CHECK: {{^}}### LOWER-TO-IR:
// CHECK-NOT: PrimalSubstitute
// CHECK: Annotation(%myFunc, {{[0-9]+}} : UInt, %myFuncSubst{{[A-Za-z0-9]*}})
// CHECK-NOT: PrimalSubstitute
// CHECK: {{^}}###{{$}}
