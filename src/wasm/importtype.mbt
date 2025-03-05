///|
extern type ImportType

///|
extern "c" fn ImportType::_module_(self : ImportType) -> Bytes = "moonbit_wasm_importtype_module"

///|
pub fn ImportType::module_(self : ImportType) -> String {
  @encoding.decoder(UTF8).decode?(self._module_()).unwrap()
}

///|
extern "c" fn ImportType::_name(self : ImportType) -> Bytes = "moonbit_wasm_importtype_name"

///|
pub fn ImportType::name(self : ImportType) -> String {
  @encoding.decoder(UTF8).decode?(self._name()).unwrap()
}

///|
extern type ImportTypeVec

///|
pub extern "c" fn ImportTypeVec::size(self : ImportTypeVec) -> Int = "moonbit_wasm_importtype_vec_size"

///|
pub extern "c" fn ImportTypeVec::op_get(
  self : ImportTypeVec,
  index : Int
) -> ImportType = "moonbit_wasm_importtype_vec_get"

///|
pub extern "c" fn ImportTypeVec::delete(self : ImportTypeVec) = "moonbit_wasm_importtype_vec_delete"

///|
pub fn ImportTypeVec::iter(self : ImportTypeVec) -> Iter[ImportType] {
  Iter::new(fn(f) {
    for i in 0..<self.size() {
      match f(self[i]) {
        IterEnd => break IterEnd
        IterContinue => ()
      }
    } else {
      IterContinue
    }
  })
}

///|
pub fn ImportTypeVec::iter2(self : ImportTypeVec) -> Iter2[Int, ImportType] {
  Iter2::new(fn(f) {
    for i in 0..<self.size() {
      match f(i, self[i]) {
        IterEnd => break IterEnd
        IterContinue => ()
      }
    } else {
      IterContinue
    }
  })
}
