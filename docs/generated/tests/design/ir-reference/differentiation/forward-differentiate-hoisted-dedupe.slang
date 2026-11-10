//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/differentiation.md#forwarddifferentiate
//META: purpose=ForwardDifferentiate is hoistable, so two __fwd_diff references to the same function are one IR value that both call sites share.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the deduplication consequence of the opcode being hoistable. Two
// syntactically separate `__fwd_diff(f)` expressions appear in one entry point.
// CHECK binds the first `ForwardDifferentiate(%f)` value to a variable, then
// requires both calls to target that same variable while a `CHECK-NOT` between
// and after them forbids any second `ForwardDifferentiate(%f)` producer. The
// closing `###` pattern bounds the whole assertion to the LOWER-TO-IR dump
// section, since the later per-pass dumps repeat the module.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform float a;
uniform float d;
uniform RWStructuredBuffer<float> buf;

[ForwardDifferentiable]
float f(float x)
{
    return x + x;
}

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = __fwd_diff(f)(DifferentialPair<float>(a, d)).d;
    buf[1] = __fwd_diff(f)(DifferentialPair<float>(d, a)).p;
}

// CHECK: {{^}}### LOWER-TO-IR:
// CHECK: let [[FWD:%[A-Za-z0-9_]+]] :{{.*}}= ForwardDifferentiate(%f)
// CHECK-NOT: = ForwardDifferentiate(%f)
// CHECK: call [[FWD]](
// CHECK-NOT: = ForwardDifferentiate(%f)
// CHECK: call [[FWD]](
// CHECK-NOT: = ForwardDifferentiate(%f)
// CHECK: {{^}}###{{$}}
