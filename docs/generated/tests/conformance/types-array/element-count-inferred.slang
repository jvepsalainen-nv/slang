//META: generated=true
//META: doc_ref=docs/language-reference/types-array.md#element-count-inference-for-unknown-length-array
//META: purpose=Element-count inference: `int a[] = {1, 2, 3, 4}` infers length 4 and is equivalent to `int a[4] = {...}`.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int a[] = { 0xA, 0xB, 0xC, 0xD };
    int b[4] = { 0xA, 0xB, 0xC, 0xD };
    bool eq = (a[0] == b[0]) && (a[1] == b[1])
           && (a[2] == b[2]) && (a[3] == b[3]);
    //CHECK: a[0..3]=10 11 12 13 eq=1
    printf("a[0..3]=%d %d %d %d eq=%d\n",
           a[0], a[1], a[2], a[3], eq ? 1 : 0);
}
