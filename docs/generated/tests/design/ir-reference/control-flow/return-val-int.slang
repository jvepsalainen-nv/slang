//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#terminators-returns-and-yields
//META: purpose=A `return expr;` in a value-returning function terminates the block with return_val(val) where val is the returned IR value.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A helper with two return paths surfaces two return_val terminators,
// each carrying its returned value as the single operand.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform RWStructuredBuffer<int> buf;

int helper(int x)
{
    if (x > 0)
        return x;
    return -x;
}

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = helper(a);
}

// CHECK-LABEL: func %helper
// CHECK: return_val(%x)
// CHECK: return_val(%{{[0-9]+}})
