//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=Verifies a chain of compound assignments (`+= *= -= /=`) lowers to read-modify-write updating the same local in source order.
//META: intent=characterization
//META: covers=source/slang/slang-lower-to-ir.cpp
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pins `visitAssignExpr` compound-assignment lowering: each op loads the
// l-value, applies the binary op, and stores back. Starting from 10:
// 10+5=15, 15*2=30, 30-3=27, 27/2=13 (integer division). CHECK asserts the
// final value 13. INTERPRET; no short-circuit operators so the slangi VM
// path is reliable.
//TEST:INTERPRET(filecheck=CHECK):
void main()
{
    int x = 10;
    x += 5;
    x *= 2;
    x -= 3;
    x /= 2;
    printf("x=%d\n", x);
    //CHECK: x=13
}
