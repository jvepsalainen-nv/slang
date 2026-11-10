//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=`enum` is a decl keyword (dispatched via direct identifier lookahead, not the syntax table) introducing an enumeration with explicit case values.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `enum` parsing is observable via the C++ emit because the
// interpreter does not implement VM bytecode for all enum operations
// in every configuration. The `enum` declaration must parse for the
// program to compile to C++ at all.

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

enum Color { Red = 7, Green = 8, Blue = 9 };

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    Color c = Color.Green;
    int v = int(c);
    //CHECK: enum
    printf("c=%d\n", v);
}
