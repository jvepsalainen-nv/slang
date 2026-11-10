//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#func
//META: purpose=The entry block of a func owns its function parameters as param children in declaration order.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a function's parameters are block parameters of its entry
// block, in declaration order. A three-parameter helper is compiled and the
// ordered CHECK lines (which advance monotonically through the dump) require
// `param %a`, `param %b`, `param %c` to appear in that sequence after the
// `func %sumTrio` label; any reordering or hoisting of the params onto the
// `func` itself would break the sequence.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int x;
uniform int y;
uniform int z;
uniform RWStructuredBuffer<int> buf;

int sumTrio(int a, int b, int c)
{
    return a + b + c;
}

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = sumTrio(x, y, z);
}

// CHECK-LABEL: func %sumTrio	: Func(Int, Int, Int, Int)
// CHECK: param %a	: Int
// CHECK: param %b	: Int
// CHECK: param %c	: Int
