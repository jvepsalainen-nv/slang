//META: generated=true
//META: doc_ref=docs/language-reference/types-vector-and-matrix.md#element-access
//META: purpose=Swizzle assign writes the named columns; the doc example `v.xz = vector<int,2>(-1, -3)` results in `{ -1, 2, -3, 4 }`.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry main -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=CUDA):-target cuda -entry main -stage compute
//TEST:SIMPLE(filecheck=CPP):-target cpp -entry main -stage compute

void main()
{
    int4 v = int4(1, 2, 3, 4);
    v.xz = int2(-1, -3);
    //CHECK: -1 2 -3 4
    //HLSL: v_0.xz = int2(
    //GLSL: v_0.xz = ivec2(
    // SwizzleAssign lowers in SPIRV to OpAccessChain on element indices 0 (x) and 2 (z).
    //SPV-DAG: OpAccessChain %_ptr_Function_int %v %int_0
    //SPV-DAG: OpAccessChain %_ptr_Function_int %v %int_2
    // CUDA lowers swizzle-assign to per-component writes: v_0.x = ...; v_0.z = ...
    //CUDA: v_0.x =
    //CUDA: v_0.z =
    // CPP lowers swizzle-assign to per-component writes using Vector<T,N>.
    //CPP: v_0.x =
    //CPP: v_0.z =
    printf("%d %d %d %d\n", v.x, v.y, v.z, v.w);
}
