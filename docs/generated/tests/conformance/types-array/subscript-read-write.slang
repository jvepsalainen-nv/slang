//META: generated=true
//META: doc_ref=docs/language-reference/types-array.md#declaration-syntax
//META: purpose=Basic subscript access: `arr[i]` reads, `arr[i] = v` writes; access is 0-indexed.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int arr[5] = { 10, 20, 30, 40, 50 };
    arr[2] = 99;
    //CHECK: 10 20 99 40 50
    printf("%d %d %d %d %d\n",
           arr[0], arr[1], arr[2], arr[3], arr[4]);
}
