///|
extern type Func

///|
extern "c" fn Func::_new(
  store : Store,
  type_ : FuncType,
  func : (ValVec, ValVec) -> Unit
) -> Func = "moonbit_wasm_func_new_with_env"

///|
pub fn Func::new(
  store : Store,
  type_ : FuncType,
  func : (Array[Val]) -> Array[Val]
) -> Func {
  Func::_new(store, type_, fn(args_vec, results_vec) {
    let args = args_vec.to()
    let results = func(args)
    results_vec.renew_uninitialized(results.length())
    for i, result in results {
      results_vec[i] = result
    }
  })
}

///|
extern "c" fn Func::as_extern_(self : Func) -> Extern_ = "moonbit_wasm_func_as_extern"

///|
pub fn Func::as_extern(self : Func) -> Extern {
  self.as_extern_().to_extern()
}

///|
pub extern "c" fn Func::param_arity(self : Func) -> Int = "moonbit_wasm_func_param_arity"

///|
pub extern "c" fn Func::result_arity(self : Func) -> Int = "moonbit_wasm_func_result_arity"

///|
extern "c" fn Func::_call(self : Func, args : ValVec, results : ValVec) -> Unit = "moonbit_wasm_func_call"

///|
pub fn Func::call(self : Func, params : Array[Val]) -> Array[Val] {
  let params_vec = ValVec::of(params)
  let results_vec = ValVec::new_uninitialized(self.result_arity())
  self._call(params_vec, results_vec)
  results_vec.to()
}
