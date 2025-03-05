# tonyfettes/wamr

This project provides MoonBit language bindings for the
[WebAssembly Micro Runtime (WAMR)](https://github.com/bytecodealliance/wasm-micro-runtime),
allowing MoonBit programs to load, instantiate, and execute WebAssembly modules.

## Quickstart

1. Build the example WASM runtime.

   ```bash
   cmake -Bbuild -GNinja .
   cmake --build build
   ```

2. Build the demo MoonBit program.

   ```bash
   cd test
   moon build --target wasm
   ```

3. Run the demo MoonBit program.

   ```bash
   ./build/src/main/main test/target/wasm/release/build/fib/fib.wasm
   ```
