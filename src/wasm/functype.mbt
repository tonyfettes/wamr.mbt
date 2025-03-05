///|
extern type FuncType

///|
extern "c" fn FuncType::_new(
  params : ValtypeVec,
  results : ValtypeVec
) -> FuncType = "moonbit_wasm_functype_new"

///|
pub fn FuncType::new(
  params : Array[Valtype],
  results : Array[Valtype]
) -> FuncType {
  FuncType::_new(ValtypeVec::of(params), ValtypeVec::of(results))
}
