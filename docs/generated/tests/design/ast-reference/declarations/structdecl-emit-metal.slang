//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T00:00:00Z
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#aggtypedecl-structdecl-classdecl-enumdecl
//META: doc_section_digest=a5782ff90acc1f9bd796853a7eeead0f64a6539af34d0a231454f705284208e7
//META: purpose=A StructDecl is emitted as a struct type by each text-emit backend; the struct keyword and field names appear in the output.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies a Slang StructDecl reaches the Metal backend as an MSL struct
// declaration. The emitted Metal text declares `struct Point_0` with both
// `int` fields; CHECK pins the struct keyword and each mangled field name,
// proving the aggregate type survives to Metal emission rather than being
// scalarized away.

//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute

struct Point { int x; int y; }

//TEST_INPUT: set outBuf = out ubuffer(data=[0 0], stride=4)
RWStructuredBuffer<int> outBuf;

//METAL: struct Point_0
//METAL: int x_{{[0-9]+}};
//METAL: int y_{{[0-9]+}};
[shader("compute")]
[numthreads(1,1,1)]
void main()
{
    Point p;
    p.x = 7;
    p.y = 8;
    outBuf[0] = p.x + p.y;
}
