///|
extern type Module

///|
pub extern "c" fn Module::new(store : Store, binary : Bytes) -> Module = "moonbit_wasm_module_new"

///|
pub extern "c" fn Module::delete(self : Module) = "moonbit_wasm_module_delete"

///|
pub extern "c" fn Module::exports(self : Module) -> ExportTypeVec = "moonbit_wasm_module_exports"

///|
pub extern "c" fn Module::imports(self : Module) -> ImportTypeVec = "moonbit_wasm_module_imports"
