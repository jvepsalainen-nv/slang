//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#debugvar
//META: purpose=A DebugVar's fourth operand is its scope: the DebugFunction for a function-level local and the DebugLexicalBlock for a local declared in a nested block.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the scope operand of DebugVar. `a` is declared at function level and
// `b` inside the braced block; the CHECK captures the function and block ids
// and requires each variable's record to end with the matching id. Variable
// names are the friendly names the IR dump prints for each DebugVar result.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute -g

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int a = int(tid.x);
    if (a > 1)
    {
        int b = a * 2;
        buf[1] = b;
    }
    buf[0] = a;
}

// CHECK: {{^}}### LOWER-TO-IR:
// CHECK: %[[FN:[0-9]+]]{{.*}}= DebugFunction("main"
// CHECK: %[[LB:[0-9]+]]{{[ \t]*}}: Void{{[ \t]*}}= DebugLexicalBlock(
// CHECK: %a{{[A-Za-z0-9_]*}}{{.*}}Ptr(Int){{.*}}= DebugVar(%{{[0-9]+}}, {{[0-9]+}} : UInt, {{[0-9]+}} : UInt, %[[FN]])
// CHECK: %b{{[A-Za-z0-9_]*}}{{.*}}Ptr(Int){{.*}}= DebugVar(%{{[0-9]+}}, {{[0-9]+}} : UInt, {{[0-9]+}} : UInt, %[[LB]])
