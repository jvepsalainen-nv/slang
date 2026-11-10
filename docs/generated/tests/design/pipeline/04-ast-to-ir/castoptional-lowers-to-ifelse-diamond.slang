//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A `CastOptionalExpr` (an `Optional<int>` value used where `Optional<float>` is expected) lowers to an if/else diamond that tests `optionalHasValue`, coerces the unwrapped value on the true side, and yields `makeOptionalNone` on the false side.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that converting between two `Optional<T>` instantiations is not a
// single pure cast inst but a control-flow diamond built by lowering.
// `widen` returns its `Optional<int>` parameter as an `Optional<float>`, which
// is the only way to reach the cast-optional lowering path. The CHECKs walk the
// emitted body in order: the has-value test, the `ifElse` terminator, the
// unwrap + element coercion on the true edge, and the none-value on the false
// edge — a shape only an if/else diamond can produce.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<float> buf;

Optional<float> widen(Optional<int> o)
{
    return o;
}

[numthreads(1, 1, 1)]
void main()
{
    Optional<int> src = a;
    Optional<float> dst = widen(src);
    buf[0] = dst.hasValue ? dst.value : 0.0f;
}

// CHECK-LABEL: func %widen
// CHECK: optionalHasValue(
// CHECK: ifElse(
// CHECK: getOptionalValue(
// CHECK: makeOptionalValue(
// CHECK: makeOptionalNone
