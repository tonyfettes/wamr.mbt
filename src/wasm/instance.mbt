///|
extern type Instance

///|
extern "c" fn Instance::_new(
  store : Store,
  module_ : Module,
  imports : FixedArray[Extern_]
) -> Instance = "moonbit_wasm_instance_new"

///|
pub fn Instance::new(
  store : Store,
  module_ : Module,
  imports : Array[Extern]
) -> Instance {
  let imports = FixedArray::makei(imports.length(), fn(i) {
    imports[i].to_extern_()
  })
  Instance::_new(store, module_, imports)
}

///|
pub extern "c" fn Instance::exports(instance : Instance) -> ExternVec = "moonbit_wasm_instance_exports"

///|
pub extern "c" fn Instance::delete(self : Instance) = "moonbit_wasm_instance_delete"
