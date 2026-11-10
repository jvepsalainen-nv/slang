//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#aggtypedecl-structdecl-classdecl-enumdecl
//META: purpose=A StructDecl survives to each text-emit backend as a named struct type rather than being scalarized away.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the same aggregate-survives-emission claim on the WGSL backend,
// where struct members use `name : type,` syntax and `int` becomes `i32`.
// The CHECKs pin the struct declaration and both member lines.

//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

struct Point { int x; int y; }

//TEST_INPUT: set outBuf = out ubuffer(data=[0 0], stride=4)
RWStructuredBuffer<int> outBuf;

//WGSL: struct Point_0
//WGSL: x_{{[0-9]+}} : i32,
//WGSL: y_{{[0-9]+}} : i32,
[shader("compute")]
[numthreads(1,1,1)]
void main()
{
    Point p;
    p.x = 7;
    p.y = 8;
    outBuf[0] = p.x + p.y;
}
