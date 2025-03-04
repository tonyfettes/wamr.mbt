///|
fn main {
  let args = @sys.get_cli_args()
  let engine = @wasm.Engine::new()
  let store = @wasm.Store::new(engine)
  let binary = @fs.read_file_to_bytes?(args[1]).unwrap()
  let module_ = @wasm.Module::new(store, binary)
  let instance = @wasm.Instance::new(store, module_, [])
  println("instantiated")
  let exports = instance.exports()
  println("exported")
  println("exports.length() = \{exports.size()}")
  let functions = []
  for export in exports {
    match exports {
      Func(func) => functions.push(func)
      _ => ()
    }
  }
  let func = functions[0]
  println("function")
  let results = func.call([@wasm.Val::I32(13)])
  guard results is [@wasm.Val::I32(result)]
  println("result: \{result}")
}
