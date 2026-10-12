# Dumper
# Win32-GUI-BinaryDecoder: Low-Level Import Explorer & FF15 Filter

A lightweight, zero-dependency binary dumper and static analysis tool written in **Free Pascal** utilizing pure **Win32 API** (`CreateWindowEx`, customized Window Procedure, and raw message loops). It bypasses heavy frameworks like VCL/LCL to achieve a minimal binary footprint and near-instant execution.

The utility is specifically designed for reverse-engineering and PE-file analysis, featuring a specialized static filter to isolate external function calls (`DLL Imports`).

## 🚀 Key Features

* **Pure Win32 API GUI:** Built entirely from scratch via native Windows header bindings. Registers its own window class (`ProcWin`) and handles interface interactions directly inside a procedural `WndProc` callback.
* **The "FF 15" Hacker Filter:** Implements an automated binary scanner that isolates the `FF 15` opcode (`CALL DWORD/QWORD PTR [Address]`), which is the standard x86/x64 instruction for indirect calls to imported DLL functions (e.g., calling `kernel32.dll` or `ntdll.dll`). 
* **Noise Reduction for Reverse Engineers:** Instead of digging through multi-megabyte raw memory or file dumps, the filtered mode outputs a clean, sequential checklist showing *only* the specific file offsets where external API calls occur.
* **Raw Hex + ASCII Preview:** Generates classic formatted output featuring `Offset | Hex Bytes | Printable ASCII Characters`, making it easy to spot hidden embedded text strings or cryptographic signatures.

## ⚠️ Known Quirks (The "To-Do" List)

This project was built as a proof-of-concept hobby utility. There are a few dirty architectural bottlenecks that need to be resolved:

1. **Hardcoded File Names (Current Limitation):** 
   Currently, the source and destination file paths (`CPU_chec_list_open_1.DMP`) are rigidly hardcoded into the `RunDumper` procedure. To dump a different file, you currently have to modify the strings in your IDE and recompile the binary. 
2. **The 16-Byte Block Boundary Bug:** 
   The filter reads data in strict 16-byte chunks. If an `FF 15` instruction happens to split across a block boundary (e.g., `FF` at index 15 of Block A and `15` at index 0 of Block B), the current algorithm will miss it.

## 🗺️ Roadmap & Future Development

* [ ] **Fix Hardcoded Paths:** Implement native Win32 `GetOpenFileName` and `GetSaveFileName` dialog boxes to allow interactive file selection without recompiling.
* [ ] **Fix Block Boundary Bug:** Implement a 1-byte trailing buffer state (`LastByte`) to correctly evaluate opcodes split across 16-byte read intervals.
* [ ] **Dynamic Process Dumping:** Migrate from static file handling to live memory analysis by integrating `OpenProcess(PROCESS_VM_READ, ...)` and `ReadProcessMemory` loop dispatchers.
* [ ] **Mini-Disassembler Engine:** Add basic opcode decoding logic. Instead of just printing raw `FF 15`, the engine will attempt to look up the import tables to resolve the actual API function name (e.g., parsing the call down to `CALL KERNEL32.GetSystemFirmwareTable`).

## 🏗 How to Compile

Requires **Free Pascal Compiler (FPC)**. Since it targets native Windows GUI subsystems, compile with the `-WG` flag to hide the redundant console window:

```bash
fpc -Mdelphi -Twin32 -WG visual_damper.pas
```

## 📜 License
MIT / Educational Resource for malware analysts, reverse engineers, and system hobbyists.
