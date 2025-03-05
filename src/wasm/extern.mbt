///|
extern type Global

///|
extern "c" fn Global::as_extern_(self : Global) -> Extern_ = "moonbit_wasm_global_as_extern"

///|
extern type Table

///|
extern "c" fn Table::as_extern_(self : Table) -> Extern_ = "moonbit_wasm_table_as_extern"

///|
extern type Memory

///|
extern "c" fn Memory::as_extern_(self : Memory) -> Extern_ = "moonbit_wasm_memory_as_extern"

///|
pub enum Extern {
  Func(Func)
  Global(Global)
  Table(Table)
  Memory(Memory)
}

///|
pub impl Show for Extern with output(self : Extern, logger : &Logger) -> Unit {
  match self {
    Func(_) => logger.write_string("Func(..)")
    Global(_) => logger.write_string("Global(..)")
    Table(_) => logger.write_string("Table(..)")
    Memory(_) => logger.write_string("Memory(..)")
  }
}

///|
fn Extern::to_extern_(self : Extern) -> Extern_ {
  match self {
    Func(func) => func.as_extern_()
    Global(global) => global.as_extern_()
    Table(table) => table.as_extern_()
    Memory(memory) => memory.as_extern_()
  }
}

///|
extern type ExternType

///|
priv extern type Extern_

///|
extern "c" fn Extern_::kind(self : Extern_) -> Byte = "moonbit_wasm_extern_kind"

///|
extern "c" fn Extern_::as_func(self : Extern_) -> Func = "moonbit_wasm_extern_as_func"

///|
extern "c" fn Extern_::as_global(self : Extern_) -> Global = "moonbit_wasm_extern_as_global"

///|
extern "c" fn Extern_::as_table(self : Extern_) -> Table = "moonbit_wasm_extern_as_table"

///|
extern "c" fn Extern_::as_memory(self : Extern_) -> Memory = "moonbit_wasm_extern_as_memory"

///|
fn Extern_::to_extern(self : Extern_) -> Extern {
  match self.kind() {
    0 => Func(self.as_func())
    1 => Global(self.as_global())
    2 => Table(self.as_table())
    3 => Memory(self.as_memory())
    kind => abort("Invalid extern kind: \{kind}")
  }
}

///|
extern type ExternVec

///|
extern "c" fn ExternVec::new() -> ExternVec = "moonbit_wasm_extern_vec_new"

///|
pub extern "c" fn ExternVec::size(self : ExternVec) -> Int = "moonbit_wasm_extern_vec_size"

///|
extern "c" fn ExternVec::get(self : ExternVec, index : Int) -> Extern_ = "moonbit_wasm_extern_vec_get"

///|
pub fn ExternVec::op_get(self : ExternVec, index : Int) -> Extern {
  self.get(index).to_extern()
}

///|
pub extern "c" fn ExternVec::delete(self : ExternVec) = "moonbit_wasm_extern_vec_delete"

///|
pub fn ExternVec::iter(self : ExternVec) -> Iter[Extern] {
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
