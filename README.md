# TCG-Storage support for QEMU

The documents and code in the repository aid the development for the support of self-encrypting drives (SED) in QEMU
that follow the TCG Storage specification.

The rough plan is:
1. Add support for Level 0 Discovery
    - Extend by Security Level 1 + 2, if needed
2. Implement features to claim Pyrite SSC V2.00 support
    - Only global locking
    - No encryption
    - No shadow MBR
3. Implement optional shadow MBR for Pyrite
4. Add features to claim Opalite SSC V2.00 support
    - Encryption support

# Development Environment

## Dependencies

### Environment
- [Task](https://taskfile.dev/)
- [Firmware-Action](https://github.com/9elements/firmware-action)

### Code
- qemu (master from 9elements)
   - will be switch to a branch with the features once development starts

## Getting started

Setup repository (for build)
```bash
git clone git@github.com:mynetz/qemu-tcg-storage.git
cd qemu-tcg-storage
git submodule update --depth 1 --init --recursive --checkout
```

Build qemu (with firmware-action)
```bash
task build:qemu
```

## Test

To validate the build QEMU runs (and as an example) the rule below exists
```bash
task run:qemu
```
Note: This should be extended in the future to run a minimal test against the implemented QEMU code