export executable "structs";

use "std.zig";

export fn main(argc : isize, argv : &&u8, env : &&u8) -> i32 {
    var foo : Foo;

    foo.a = foo.a + 1;

    foo.b = foo.a == 1;

    test_foo(foo);

    modify_foo(&foo);

    if foo.c != 100 {
        print_str("BAD\n");
    }

    test_point_to_self();

    print_str("OK\n");
    return 0;
}

struct Foo {
    a : i32,
    b : bool,
    c : f32,
}

struct Node {
    val: i32,
    next: &Node,
}

fn test_foo(foo : Foo) {
    if !foo.b {
        print_str("BAD\n");
    }
}

fn modify_foo(foo : &Foo) {
    foo.c = 100;
}

fn test_point_to_self() {
    var root : Node;
    root.val = 1;

    var node : Node;
    node.next = &root;
    node.val = 2;

    if node.next.val != 1 {
        print_str("BAD\n");
    }
}
