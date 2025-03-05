///|
extern type Valtype

///|
extern "c" fn Valtype::_new(kind : Byte) -> Valtype = "moonbit_wasm_valtype_new"

///|
pub fn Valtype::new(kind : ValKind) -> Valtype {
  Valtype::_new(kind.to_byte())
}

///|
extern "c" fn Valtype::_kind(self : Valtype) -> Byte = "moonbit_wasm_valtype_kind"

///|
pub fn Valtype::kind(self : Valtype) -> ValKind {
  ValKind::of_byte(self._kind())
}

///|
pub extern "c" fn Valtype::delete(self : Valtype) = "moonbit_wasm_valtype_delete"

///|
extern type ValtypeVec

///|
extern "c" fn ValtypeVec::new(
  size : Int,
  data : FixedArray[Valtype]
) -> ValtypeVec = "moonbit_wasm_valtype_vec_new"

///|
pub extern "c" fn ValtypeVec::size(self : ValtypeVec) -> Int = "moonbit_wasm_valtype_vec_size"

///|
pub extern "c" fn ValtypeVec::op_get(self : ValtypeVec, index : Int) -> Valtype = "moonbit_wasm_valtype_vec_get"

///|
pub extern "c" fn ValtypeVec::op_set(
  self : ValtypeVec,
  index : Int,
  valtype : Valtype
) = "moonbit_wasm_valtype_vec_set"

///|
pub extern "c" fn ValtypeVec::delete(self : ValtypeVec) = "moonbit_wasm_valtype_vec_delete"

///|
pub fn ValtypeVec::iter(self : ValtypeVec) -> Iter[Valtype] {
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
pub fn ValtypeVec::of(array : Array[Valtype]) -> ValtypeVec {
  let array = FixedArray::from_array(array)
  let vec = ValtypeVec::new(array.length(), array)
  for i in 0..<array.length() {
    vec.op_set(i, array[i])
  }
  vec
}
