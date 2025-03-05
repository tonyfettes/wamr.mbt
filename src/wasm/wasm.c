#include "../wamr/core/iwasm/include/wasm_c_api.h"
#include <moonbit.h>
#include <stdio.h>
#include <stdlib.h>

void *
moonbit_ffi_make_closure(void *function, void *callback) {
  return callback;
}

void *
moonbit_c_null() {
  return NULL;
}

bool
moonbit_c_is_null(void *ptr) {
  return ptr == NULL;
}

wasm_engine_t *
moonbit_wasm_engine_new() {
  return wasm_engine_new();
}

wasm_store_t *
moonbit_wasm_store_new(wasm_engine_t *engine) {
  return wasm_store_new(engine);
}

bool
moonbit_wasm_module_validate(
  wasm_store_t *store,
  const wasm_byte_vec_t *binary
) {
  return wasm_module_validate(store, binary);
}

_Static_assert(sizeof(wasm_byte_t) == sizeof(char), "incompatible byte type");

wasm_module_t *
moonbit_wasm_module_new(wasm_store_t *store, const moonbit_bytes_t binary) {
  wasm_byte_vec_t byte_vec = {
    .size = Moonbit_array_length(binary),
    .data = (char *)binary,
  };
  wasm_module_t *module = wasm_module_new(store, &byte_vec);
  moonbit_decref(binary);
  return module;
}

void
moonbit_wasm_module_delete(wasm_module_t *module) {
  wasm_module_delete(module);
}

wasm_valtype_t *
moonbit_wasm_valtype_new(wasm_valkind_t kind) {
  return wasm_valtype_new(kind);
}

wasm_valkind_t
moonbit_wasm_valtype_kind(wasm_valtype_t *valtype) {
  return wasm_valtype_kind(valtype);
}

wasm_valtype_vec_t *
moonbit_wasm_valtype_vec_new(int size, wasm_valtype_t **data) {
  wasm_valtype_vec_t *vec = malloc(sizeof(wasm_valtype_vec_t));
  wasm_valtype_vec_new(vec, size, data);
  return vec;
}

int
moonbit_wasm_valtype_vec_size(wasm_valtype_vec_t *vec) {
  return vec->size;
}

wasm_valtype_t *
moonbit_wasm_valtype_vec_get(wasm_valtype_vec_t *vec, int index) {
  return vec->data[index];
}

void
moonbit_wasm_valtype_vec_set(
  wasm_valtype_vec_t *vec,
  int index,
  wasm_valtype_t *valtype
) {
  vec->data[index] = valtype;
}

void
moonbit_wasm_valtype_vec_delete(wasm_valtype_vec_t *vec) {
  wasm_valtype_vec_delete(vec);
  free(vec);
}

wasm_functype_t *
moonbit_wasm_functype_new(
  wasm_valtype_vec_t *params,
  wasm_valtype_vec_t *results
) {
  wasm_functype_t *functype = wasm_functype_new(params, results);
  return functype;
}

moonbit_bytes_t
moonbit_wasm_importtype_module(wasm_importtype_t *self) {
  const wasm_byte_vec_t *module_byte_vec = wasm_importtype_module(self);
  size_t size = module_byte_vec->size - 1;
  moonbit_bytes_t module_bytes = moonbit_make_bytes(size, 0);
  for (int i = 0; i < size; i++) {
    module_bytes[i] = module_byte_vec->data[i];
  }
  return module_bytes;
}

moonbit_bytes_t
moonbit_wasm_importtype_name(wasm_importtype_t *self) {
  const wasm_byte_vec_t *name_byte_vec = wasm_importtype_name(self);
  size_t size = name_byte_vec->size - 1;
  moonbit_bytes_t name_bytes = moonbit_make_bytes(size, 0);
  for (int i = 0; i < size; i++) {
    name_bytes[i] = name_byte_vec->data[i];
  }
  return name_bytes;
}

const wasm_externtype_t *
moonbit_wasm_importtype_type(const wasm_importtype_t *self) {
  return wasm_importtype_type(self);
}

int
moonbit_wasm_importtype_vec_size(wasm_importtype_vec_t *self) {
  return self->size;
}

wasm_importtype_t *
moonbit_wasm_importtype_vec_get(wasm_importtype_vec_t *self, int index) {
  return self->data[index];
}

void
moonbit_wasm_importtype_vec_delete(wasm_importtype_vec_t *self) {
  wasm_importtype_vec_delete(self);
  free(self);
}

wasm_importtype_vec_t *
moonbit_wasm_module_imports(wasm_module_t *module) {
  wasm_importtype_vec_t *vec = malloc(sizeof(wasm_importtype_vec_t));
  wasm_importtype_vec_new_empty(vec);
  wasm_module_imports(module, vec);
  return vec;
}

moonbit_bytes_t
moonbit_wasm_exporttype_name(wasm_exporttype_t *self) {
  const wasm_byte_vec_t *name_byte_vec = wasm_exporttype_name(self);
  size_t size = name_byte_vec->size - 1;
  moonbit_bytes_t name_bytes = moonbit_make_bytes(size, 0);
  for (int i = 0; i < size; i++) {
    name_bytes[i] = name_byte_vec->data[i];
  }
  return name_bytes;
}

int
moonbit_wasm_exporttype_vec_size(wasm_exporttype_vec_t *self) {
  return self->size;
}

wasm_exporttype_t *
moonbit_wasm_exporttype_vec_get(wasm_exporttype_vec_t *self, int index) {
  return self->data[index];
}

void
moonbit_wasm_exporttype_vec_delete(wasm_exporttype_vec_t *self) {
  wasm_exporttype_vec_delete(self);
  free(self);
}

wasm_exporttype_vec_t *
moonbit_wasm_module_exports(wasm_module_t *module) {
  wasm_exporttype_vec_t *vec = malloc(sizeof(wasm_exporttype_vec_t));
  wasm_exporttype_vec_new_empty(vec);
  wasm_module_exports(module, vec);
  return vec;
}

typedef struct moonbit_wasm_func_callback {
  int (*callback)(
    struct moonbit_wasm_func_callback *,
    const wasm_val_vec_t *args,
    wasm_val_vec_t *results
  );
} moonbit_wasm_func_callback_t;

wasm_trap_t *
moonbit_wasm_func_callback_with_env(
  void *env,
  const wasm_val_vec_t *args,
  wasm_val_vec_t *results
) {
  moonbit_wasm_func_callback_t *callback = (moonbit_wasm_func_callback_t *)env;
  moonbit_incref(callback);
  callback->callback(callback, args, results);
  return NULL;
}

wasm_func_t *
moonbit_wasm_func_new_with_env(
  wasm_store_t *store,
  const wasm_functype_t *type,
  moonbit_wasm_func_callback_t *callback
) {
  wasm_func_t *func = wasm_func_new_with_env(
    store, type, moonbit_wasm_func_callback_with_env, callback, NULL
  );
  return func;
}

wasm_externkind_t
moonbit_wasm_extern_kind(wasm_extern_t *extern_) {
  return wasm_extern_kind(extern_);
}

wasm_func_t *
moonbit_wasm_extern_as_func(wasm_extern_t *extern_) {
  wasm_func_t *func = wasm_extern_as_func(extern_);
  return func;
}

wasm_global_t *
moonbit_wasm_extern_as_global(wasm_extern_t *extern_) {
  return wasm_extern_as_global(extern_);
}

wasm_table_t *
moonbit_wasm_extern_as_table(wasm_extern_t *extern_) {
  return wasm_extern_as_table(extern_);
}

wasm_memory_t *
moonbit_wasm_extern_as_memory(wasm_extern_t *extern_) {
  return wasm_extern_as_memory(extern_);
}

wasm_extern_t *
moonbit_wasm_func_as_extern(wasm_func_t *func) {
  return wasm_func_as_extern(func);
}

wasm_extern_t *
moonbit_wasm_global_as_extern(wasm_global_t *global) {
  return wasm_global_as_extern(global);
}

wasm_extern_t *
moonbit_wasm_table_as_extern(wasm_table_t *table) {
  return wasm_table_as_extern(table);
}

wasm_extern_t *
moonbit_wasm_memory_as_extern(wasm_memory_t *memory) {
  return wasm_memory_as_extern(memory);
}

wasm_instance_t *
moonbit_wasm_instance_new(
  wasm_store_t *store,
  wasm_module_t *module,
  wasm_extern_t **imports
) {
  wasm_extern_vec_t imports_vec;
  wasm_extern_vec_new(&imports_vec, Moonbit_array_length(imports), imports);
  wasm_instance_t *instance =
    wasm_instance_new(store, module, &imports_vec, NULL);
  moonbit_decref(imports);
  return instance;
}

wasm_extern_vec_t *
moonbit_wasm_instance_exports(wasm_instance_t *instance) {
  wasm_extern_vec_t *exports = malloc(sizeof(wasm_extern_vec_t));
  wasm_extern_vec_new_empty(exports);
  wasm_instance_exports(instance, exports);
  return exports;
}

wasm_extern_vec_t *
moonbit_wasm_extern_vec_new() {
  wasm_extern_vec_t *vec = malloc(sizeof(wasm_extern_vec_t));
  wasm_extern_vec_new_empty(vec);
  return vec;
}

int
moonbit_wasm_extern_vec_size(wasm_extern_vec_t *vec) {
  return vec->size;
}

wasm_extern_t *
moonbit_wasm_extern_vec_get(wasm_extern_vec_t *vec, uint32_t index) {
  return vec->data[index];
}

void
moonbit_wasm_extern_vec_delete(wasm_extern_vec_t *vec) {
  wasm_extern_vec_delete(vec);
  free(vec);
}

wasm_val_vec_t *
moonbit_wasm_val_vec_new_uninitialized(int size) {
  wasm_val_vec_t *vec = malloc(sizeof(wasm_val_vec_t));
  wasm_val_vec_new_uninitialized(vec, size);
  return vec;
}

void
moonbit_wasm_val_vec_renew_uninitialized(wasm_val_vec_t *vec, int size) {
  wasm_val_vec_new_uninitialized(vec, size);
}

int
moonbit_wasm_val_vec_size(wasm_val_vec_t *vec) {
  return vec->size;
}

void
moonbit_wasm_val_vec_set_i32(wasm_val_vec_t *vec, int index, int val) {
  vec->data[index].kind = WASM_I32;
  vec->data[index].of.i32 = val;
}

void
moonbit_wasm_val_vec_set_i64(wasm_val_vec_t *vec, int index, int64_t val) {
  vec->data[index].kind = WASM_I64;
  vec->data[index].of.i64 = val;
}

void
moonbit_wasm_val_vec_set_f32(wasm_val_vec_t *vec, int index, float val) {
  vec->data[index].kind = WASM_F32;
  vec->data[index].of.f32 = val;
}

void
moonbit_wasm_val_vec_set_f64(wasm_val_vec_t *vec, int index, double val) {
  vec->data[index].kind = WASM_F64;
  vec->data[index].of.f64 = val;
}

void
moonbit_wasm_val_vec_delete(wasm_val_vec_t *vec) {
  wasm_val_vec_delete(vec);
  free(vec);
}

int
moonbit_wasm_val_vec_get_valkind(wasm_val_vec_t *vec, int index) {
  return vec->data[index].kind;
}

int
moonbit_wasm_val_vec_get_i32(wasm_val_vec_t *vec, int index) {
  return vec->data[index].of.i32;
}

int64_t
moonbit_wasm_val_vec_get_i64(wasm_val_vec_t *vec, int index) {
  return vec->data[index].of.i64;
}

float
moonbit_wasm_val_vec_get_f32(wasm_val_vec_t *vec, int index) {
  return vec->data[index].of.f32;
}

double
moonbit_wasm_val_vec_get_f64(wasm_val_vec_t *vec, int index) {
  return vec->data[index].of.f64;
}

int
moonbit_wasm_func_param_arity(wasm_func_t *func) {
  return wasm_func_param_arity(func);
}

int
moonbit_wasm_func_result_arity(wasm_func_t *func) {
  return wasm_func_result_arity(func);
}

void
moonbit_wasm_func_call(
  wasm_func_t *func,
  wasm_val_vec_t *args,
  wasm_val_vec_t *results
) {
  wasm_func_call(func, args, results);
}
