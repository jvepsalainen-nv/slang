//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#accessordecl-family
//META: purpose=A RefAccessorDecl (`ref`) keeps the property assignable, and the HLSL backend compiles the assignment through it.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the same `ref` accessor claim on WGSL, where the accessor becomes a
// helper returning `ptr<function, i32>` into the backing field. The CHECKs pin
// the pointer-returning signature, the field return, and the call used as an
// assignment target.

//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

struct Cell
{
    int _v;
    property int value
    {
        get { return _v; }
        [mutating] ref { return _v; }
    }
}

//TEST_INPUT: set outBuf = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outBuf;

//WGSL: fn Cell_value_ref_0({{.*}}ptr<function, Cell_0>){{.*}}-> ptr<function, i32>
//WGSL: return {{.*}}._v_{{[0-9]+}};
//WGSL: Cell_value_ref_0({{.*}}) = i32(13);
[shader("compute")]
[numthreads(1,1,1)]
void main()
{
    Cell c;
    c._v = 0;
    c.value = 13;
    outBuf[0] = c.value;
}
