//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=3250005059a2746ebc504a9d3f71ed112f1f2b94
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#operator-precedence-and-parenthesization
//META: doc_section_digest=71c6e6a3dd9f98cd8871ef646710647c71e8dc0f8d4f04eda428d745f76e66a0
//META: purpose=Stress: a deeply nested arithmetic expression `((a+b)*(c+d)) - (a*b) + c*d` is emitted with the minimum parentheses set — additions stay parenthesised when they sit under a multiplication, but mul-precedence subexpressions are not over-wrapped.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the deeply-nested precedence stress onto GLSL, Metal, and
// WGSL — the existing sibling (precedence-deeply-nested-arith-stress.slang)
// only pins the minimum-paren shape on HLSL. Operands are `uniform`
// globals so the folder cannot collapse the expression. On every C-like
// infix target the additions under the multiplication keep their parens
// while the multiplications under the `-`/`+` drop theirs. (SPIR-V is
// SSA and has no infix-arithmetic text form — see the Untested row.)

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

uniform int a;
uniform int b;
uniform int c;
uniform int d;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = ((a + b) * (c + d)) - (a * b) + c * d;
}

// GLSL: ({{.*}} + {{.*}}) * ({{.*}} + {{.*}}) - {{.*}} * {{.*}} + {{.*}} * {{.*}}
// METAL: ({{.*}} + {{.*}}) * ({{.*}} + {{.*}}) - {{.*}} * {{.*}} + {{.*}} * {{.*}}
// WGSL: ({{.*}} + {{.*}}) * ({{.*}} + {{.*}}) - {{.*}} * {{.*}} + {{.*}} * {{.*}}
