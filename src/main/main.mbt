///|
type! RuntimeError {
  InvalidExportType(expect~ : String, actual~ : String)
  MissingStart
  ImportNotFound(module_~ : String, name~ : String)
} derive(Show)

///|
fn main {
  try {
    let args = @sys.get_cli_args()
    let engine = @wasm.Engine::new()
    let store = @wasm.Store::new(engine)
    let buffer = StringBuilder::new()
    let imports = {
      "spectest": {
        "print_char": @wasm.Func::new(
          store,
          @wasm.FuncType::new([@wasm.Valtype::new(@wasm.ValKind::I32)], []),
          fn(args) {
            guard args is [@wasm.Val::I32(char)]
            let char = Char::from_int(char)
            if char == '\n' {
              println(buffer.to_string())
              buffer.reset()
            } else {
              buffer.write_char(char)
            }
            []
          },
        ).as_extern(),
      },
    }
    let binary = @fs.read_file_to_bytes?(args[1]).unwrap()
    let module_ = @wasm.Module::new(store, binary)
    let module_imports = module_.imports()
    let module_exports = module_.exports()
    let instance_imports = []
    for import_type in module_imports {
      let module_ = import_type.module_()
      let name = import_type.name()
      guard imports[module_] is Some(module_) && module_[name] is Some(import_) else {
        raise ImportNotFound(module_~, name~)
      }
      instance_imports.push(import_)
    }
    let instance = @wasm.Instance::new(store, module_, instance_imports)
    let instance_exports = instance.exports()
    let start = for i, export in module_exports {
      if export.name() == "_start" {
        match instance_exports[i] {
          Func(func) => break func
          export =>
            raise InvalidExportType(expect="Func(..)", actual="\{export}")
        }
      }
    } else {
      raise MissingStart
    }
    guard start.param_arity() == 0
    guard start.result_arity() == 0
    guard start.call([]) is []

  } catch {
    error => {
      println("Error: \{error}")
      panic()
    }
  }
}
