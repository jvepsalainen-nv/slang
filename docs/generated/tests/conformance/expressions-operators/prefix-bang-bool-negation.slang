//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operators.md#prefix-operator-expressions
//META: purpose=Prefix `!` is Boolean negation per the operator table; `!true` is `false` and `!false` is `true`.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Two probe overloads to distinguish bool values from int values
// (and to dodge the slangi VM bool-arg bug we filed as #11402:
// we never pass the bool LITERAL as a bool argument — we pass an
// `int` ?: expression instead).

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    bool x = true;
    bool y = false;
    bool nx = !x;
    bool ny = !y;
    int nxInt = nx ? 1 : 0;
    int nyInt = ny ? 1 : 0;
    //CHECK: nxInt=0 nyInt=1
    printf("nxInt=%d nyInt=%d\n", nxInt, nyInt);
}
