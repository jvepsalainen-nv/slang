//META: generated=true
//META: doc_ref=docs/language-reference/expressions-member-access.md#matrix-swizzles
//META: purpose=Matrix zero-based `_mij` swizzle: `m._m12` reads row 1, column 2 (zero-indexed).
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    matrix<int, 3, 3> m = {
        10, 11, 12,
        20, 21, 22,
        30, 31, 32,
    };
    //CHECK: m00=10 m12=22 m21=31
    printf("m00=%d m12=%d m21=%d\n",
           m._m00, m._m12, m._m21);
}
