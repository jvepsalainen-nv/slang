//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#container-level-cap
//META: purpose=A type's visibility is the minimum of its own declaration's visibility and its declaration-reference generic arguments, so a `public` generic specialized on an `internal` argument is itself less visible.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the min-over-generic-arguments rule. `Box` is explicitly `public`
// but `Key` carries no modifier, so it is `internal`; `Box<Key>` therefore
// resolves to `internal`. A `public` function naming `Box<Key>` in its
// signature must then reference a less visible type. The CHECK pins E30604
// and shows the reported type is the specialization `Box<Key>`, not `Box`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct Key { int k; }

public struct Box<T> { T value; }

public Box<Key> makeBox(Box<Key> b) { return b; }
//CHECK:        ^^^^^^^ references less visible type
//CHECK:        ^^^^^^^ 'makeBox' references less visible type 'Box<Key>'.
// CHECK: E30604
