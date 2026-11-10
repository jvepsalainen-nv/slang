//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#statement-keywords
//META: purpose=`switch`, `case`, and `default` form the multi-way dispatch statement; the parser recognizes all three as statement keywords.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The interpreter cannot evaluate `switch` bytecode in all
// configurations, so we observe the parse instead by checking that
// the emitted C++ contains a `switch` construct. If the parser
// dropped `case` or `default`, the program would not compile.

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

int classify(int v)
{
    switch (v)
    {
    case 1:  return 100;
    case 2:  return 200;
    default: return 999;
    }
}

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    int a = classify(1) + classify(2) + classify(5);
    //CHECK: switch
    printf("a=%d\n", a);
}
