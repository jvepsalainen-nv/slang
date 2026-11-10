//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#terminators-no-continuation
//META: purpose=Boundary: an if/else in which both arms `return` leaves the synthesized merge block terminated by `unreachable` — `unreachable` is not unique to switch all-arms-return.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Both arms of the if/else return, so no path reaches the synthesized
// merge block. The lowering pass terminates that merge with
// `unreachable` — the natural surface for the no-continuation
// terminator alongside the switch case already in the bundle.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform RWStructuredBuffer<int> buf;

int helper(int x)
{
    if (x > 0)
    {
        return x;
    }
    else
    {
        return -x;
    }
}

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = helper(a);
}

// CHECK-LABEL: func %helper
// CHECK: ifElse(%{{[0-9]+}}, %{{[0-9]+}}, %{{[0-9]+}}, %{{[0-9]+}})
// CHECK: return_val(%x)
// CHECK: unreachable
