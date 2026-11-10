//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#global-state
//META: purpose=A static const int at module scope lowers to a globalConstant opcode wrapping the literal value.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a module-scope `static const` keeps a dedicated opcode instead
// of being propagated into its uses at lowering time. CHECK requires
// `let %gK : Int = globalConstant(42 : Int)`; a plain `let %gK : Int = 42 : Int`
// would mean the constant lost its module-scope identity (and with it the
// linkage that lets another module refer to it).

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

static const int gK = 42;

uniform int n;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = gK + n;
}

// CHECK: let  %gK	: Int	= globalConstant(42 : Int)
