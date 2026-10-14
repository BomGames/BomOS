@echo off
setlocal
cd /d "%~dp0"
for /f "delims=" %%P in ('py -c "import pathlib,ziglang; print(pathlib.Path(ziglang.__file__).parent)"') do set "ZIG_PACKAGE=%%P"
if not defined ZIG_PACKAGE (
    echo Install Python and Zig first: py -m pip install ziglang
    exit /b 1
)
set "ZIG=%ZIG_PACKAGE%\zig.exe"
if not exist build mkdir build
"%ZIG%" cc -target x86-freestanding -O2 -ffreestanding -fno-pic -fno-pie -fno-stack-protector -fno-builtin -mno-sse -mno-mmx -c boot.S -o build\boot.o
if errorlevel 1 exit /b %errorlevel%
"%ZIG%" cc -target x86-freestanding -O2 -ffreestanding -fno-pic -fno-pie -fno-stack-protector -fno-builtin -mno-sse -mno-mmx -c kernel.c -o build\kernel.o
if errorlevel 1 exit /b %errorlevel%
"%ZIG%" cc -target x86-freestanding -nostdlib -no-pie -Wl,-T,linker.ld -Wl,-z,noexecstack -Wl,--build-id=none -o bomos.bin build\boot.o build\kernel.o
if errorlevel 1 exit /b %errorlevel%
echo Built BomOS 0.5 kernel: "%~dp0bomos.bin"
