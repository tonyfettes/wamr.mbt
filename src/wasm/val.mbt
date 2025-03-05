///|
pub(all) enum ValKind {
  I32
  I64
  F32
  F64
}

///|
fn ValKind::of_byte(kind : Byte) -> ValKind {
  match kind {
    0 => ValKind::I32
    1 => ValKind::I64
    2 => ValKind::F32
    3 => ValKind::F64
    kind => abort("invalid ValKind: \{kind}")
  }
}

///|
fn ValKind::to_byte(self : ValKind) -> Byte {
  match self {
    ValKind::I32 => 0
    ValKind::I64 => 1
    ValKind::F32 => 2
    ValKind::F64 => 3
  }
}

///|
pub(all) enum Val {
  I32(Int)
  I64(Int)
  F32(Float)
  F64(Float)
}

///|
extern type ValVec

///|
extern "c" fn ValVec::new_uninitialized(size : Int) -> ValVec = "moonbit_wasm_val_vec_new_uninitialized"

///|
extern "c" fn ValVec::renew_uninitialized(self : ValVec, size : Int) = "moonbit_wasm_val_vec_renew_uninitialized"

///|
extern "c" fn ValVec::size(self : ValVec) -> Int = "moonbit_wasm_val_vec_size"

///|
extern "c" fn ValVec::set_i32(self : ValVec, index : Int, val : Int) = "moonbit_wasm_val_vec_set_i32"

///|
extern "c" fn ValVec::set_i64(self : ValVec, index : Int, val : Int) = "moonbit_wasm_val_vec_set_i64"

///|
extern "c" fn ValVec::set_f32(self : ValVec, index : Int, val : Float) = "moonbit_wasm_val_vec_set_f32"

///|
extern "c" fn ValVec::set_f64(self : ValVec, index : Int, val : Float) = "moonbit_wasm_val_vec_set_f64"

///|
extern "c" fn ValVec::_get_valkind(self : ValVec, index : Int) -> Byte = "moonbit_wasm_val_vec_get_valkind"

///|
fn ValVec::get_valkind(self : ValVec, index : Int) -> ValKind {
  ValKind::of_byte(self._get_valkind(index))
}

///|
extern "c" fn ValVec::get_i32(self : ValVec, index : Int) -> Int = "moonbit_wasm_val_vec_get_i32"

///|
extern "c" fn ValVec::get_i64(self : ValVec, index : Int) -> Int = "moonbit_wasm_val_vec_get_i64"

///|
extern "c" fn ValVec::get_f32(self : ValVec, index : Int) -> Float = "moonbit_wasm_val_vec_get_f32"

///|
extern "c" fn ValVec::get_f64(self : ValVec, index : Int) -> Float = "moonbit_wasm_val_vec_get_f64"

///|
pub fn ValVec::op_set(self : ValVec, index : Int, val : Val) -> Unit {
  match val {
    Val::I32(i) => self.set_i32(index, i)
    Val::I64(i) => self.set_i64(index, i)
    Val::F32(f) => self.set_f32(index, f)
    Val::F64(f) => self.set_f64(index, f)
  }
}

///|
pub fn ValVec::of(val : Array[Val]) -> ValVec {
  let vec = ValVec::new_uninitialized(val.length())
  for i, v in val {
    vec[i] = v
  }
  vec
}

///|
pub fn ValVec::to(self : ValVec) -> Array[Val] {
  let vals = []
  for i in 0..<self.size() {
    match self.get_valkind(i) {
      ValKind::I32 => vals.push(Val::I32(self.get_i32(i)))
      ValKind::I64 => vals.push(Val::I64(self.get_i64(i)))
      ValKind::F32 => vals.push(Val::F32(self.get_f32(i)))
      ValKind::F64 => vals.push(Val::F64(self.get_f64(i)))
    }
  }
  vals
}
