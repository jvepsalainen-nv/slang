//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#global-state
//META: purpose=A function-static const local lowers to a module-scope globalConstant carrying its value operand.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the second AST origin of `globalConstant`: a `static const` declared
// inside a function body. CHECK requires the constant to surface as a
// module-scope `let %K : Int = globalConstant(7 : Int)` rather than as a
// function-local inst, which is the same treatment a module-scope `static
// const` gets.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int n;
uniform RWStructuredBuffer<int> buf;

int scaled()
{
    static const int K = 7;
    return K * n;
}

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = scaled();
}

// CHECK: [nameHint("K")]
// CHECK-NEXT: let  %K	: Int	= globalConstant(7 : Int)
