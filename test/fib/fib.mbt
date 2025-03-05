///|
fn fib(n : Int) -> Int {
  match n {
    0 => 1
    1 => 1
    n => fib(n - 1) + fib(n - 2)
  }
}

fn main {
  println("fib(10) = \{fib(10)}")
}
