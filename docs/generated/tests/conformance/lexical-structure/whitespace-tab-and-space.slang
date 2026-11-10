//META: generated=true
//META: doc_ref=docs/language-reference/lexical-structure.md#whitespace
//META: purpose=Both space (U+0020) and horizontal tab (U+0009) count as horizontal whitespace per the doc; either may separate tokens.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
	int		a	=	5;	// tabs throughout (this line is intentionally tab-separated)
    int b = 7;
    int sum = a	+	b;
    //CHECK: sum=12
    printf("sum=%d\n", sum);
}
