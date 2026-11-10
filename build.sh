#!/usr/bin/env bash
set -e

B=$(cd "$(dirname "$0")" && pwd)
cd "$B"

OUTPUT_PACK="seltos-convenience-pack.zip"
OUTPUT_USB="../downloads/seltos-convenience-usb.zip"

echo "==> 1. Building ${OUTPUT_PACK} with explicit UNIX permissions..."
rm -f "${OUTPUT_PACK}"

python3 -c "
import os, stat, time, zipfile

targets = ['NEMESIS.data', 'bin', 'etc', 'scripts', 'svc', 'hmgapi']
pack_name = '${OUTPUT_PACK}'

with zipfile.ZipFile(pack_name, 'w', zipfile.ZIP_DEFLATED) as z:
    for target in targets:
        if os.path.isfile(target):
            files = [target]
        elif os.path.isdir(target):
            files = []
            for root, dirs, fnames in os.walk(target):
                for f in fnames:
                    files.append(os.path.join(root, f))
        else:
            continue

        for fpath in files:
            arcname = os.path.relpath(fpath, '.')
            st = os.stat(fpath)
            with open(fpath, 'rb') as fp:
                data = fp.read()
            
            info = zipfile.ZipInfo(arcname)
            info.date_time = time.localtime(st.st_mtime)[:6]
            info.compress_type = zipfile.ZIP_DEFLATED
            
            # Explicit executable permission (0o755) for scripts
            if arcname.endswith('.sh') or arcname.startswith(('bin/', 'scripts/', 'svc/')):
                mode = 0o100755
            else:
                mode = 0o100644
                
            info.external_attr = mode << 16
            z.writestr(info, data)

print('Built ${OUTPUT_PACK} successfully.')
"

cp "${OUTPUT_PACK}" "../downloads/${OUTPUT_PACK}"

echo "==> 2. Building ${OUTPUT_USB} for USB root installation..."
rm -f "${OUTPUT_USB}"

python3 -c "
import os, stat, time, zipfile

usb_zip_path = '${OUTPUT_USB}'
pack_file = '${OUTPUT_PACK}'

root_nemesis_data = b'''[nemesis]
version=1.0
type=install
path=packages/seltos.convenience.zip
'''

readme_text = b'''Seltos Convenience Suite v1.6.0 - USB Install Guide
===================================================

1. USB Format: FAT32 format (32GB or smaller recommended).
2. Root Structure:
   USB Drive (Top Level)
   \xe2\x94\x9c\xe2\x94\x80\xe2\x94\x80 NEMESIS.data
   \xe2\x94\x9c\xe2\x94\x80\xe2\x94\x80 README.txt
   \xe2\x94\x94\xe2\x94\x80\xe2\x94\x80 packages
       \xe2\x94\x94\xe2\x94\x80\xe2\x94\x80 seltos.convenience.zip

3. In-Car Execution:
   - Start vehicle and wait for head unit navigation to fully boot.
   - Insert USB drive into front multimedia USB port.
   - When NEMESIS prompts to install package, tap 'Yes' within 60s.
   - After installation toast appears, reboot head unit via RESET pinhole.
'''

with zipfile.ZipFile(usb_zip_path, 'w', zipfile.ZIP_DEFLATED) as z:
    # 1. Root NEMESIS.data (trigger)
    info1 = zipfile.ZipInfo('NEMESIS.data')
    info1.date_time = (2026, 11, 10, 17, 50, 0)
    info1.compress_type = zipfile.ZIP_DEFLATED
    info1.external_attr = 0o100644 << 16
    z.writestr(info1, root_nemesis_data)

    # 2. Root README.txt
    info2 = zipfile.ZipInfo('README.txt')
    info2.date_time = (2026, 11, 10, 17, 50, 0)
    info2.compress_type = zipfile.ZIP_DEFLATED
    info2.external_attr = 0o100644 << 16
    z.writestr(info2, readme_text)

    # 3. packages/seltos.convenience.zip
    st = os.stat(pack_file)
    with open(pack_file, 'rb') as fp:
        pack_data = fp.read()
    info3 = zipfile.ZipInfo('packages/seltos.convenience.zip')
    info3.date_time = time.localtime(st.st_mtime)[:6]
    info3.compress_type = zipfile.ZIP_DEFLATED
    info3.external_attr = 0o100644 << 16
    z.writestr(info3, pack_data)

print('Built ${OUTPUT_USB} successfully.')
"

echo "==> 3. Verifying package and USB contents..."
python3 -c "
import zipfile, io

print('--- packages/seltos.convenience.zip check ---')
with zipfile.ZipFile('${OUTPUT_USB}') as uz:
    inner = uz.read('packages/seltos.convenience.zip')
    with zipfile.ZipFile(io.BytesIO(inner)) as pz:
        for info in pz.infolist():
            if info.filename.endswith('.sh') or 'NEMESIS' in info.filename or 'wireless' in info.filename:
                print(f'{info.filename:45s} mode: {oct(info.external_attr >> 16)}')

print('--- USB root check ---')
with zipfile.ZipFile('${OUTPUT_USB}') as uz:
    for name in uz.namelist():
        print(name)
    print('--- Root NEMESIS.data Content ---')
    print(uz.read('NEMESIS.data').decode('utf-8'))
"
