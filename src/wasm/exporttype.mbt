///|
extern type ExportType

///|
extern "c" fn ExportType::_name(self : ExportType) -> Bytes = "moonbit_wasm_exporttype_name"

///|
pub fn ExportType::name(self : ExportType) -> String {
  @encoding.decoder(UTF8).decode?(self._name()).unwrap()
}

///|
extern type ExportTypeVec

///|
pub extern "c" fn ExportTypeVec::size(self : ExportTypeVec) -> Int = "moonbit_wasm_exporttype_vec_size"

///|
pub extern "c" fn ExportTypeVec::op_get(
  self : ExportTypeVec,
  index : Int
) -> ExportType = "moonbit_wasm_exporttype_vec_get"

///|
pub extern "c" fn ExportTypeVec::delete(self : ExportTypeVec) = "moonbit_wasm_exporttype_vec_delete"

///|
pub fn ExportTypeVec::iter(self : ExportTypeVec) -> Iter[ExportType] {
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
pub fn ExportTypeVec::iter2(self : ExportTypeVec) -> Iter2[Int, ExportType] {
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
