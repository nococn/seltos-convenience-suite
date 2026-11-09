#!/usr/bin/env bash
set -e

OUTPUT_ZIP="seltos-convenience-pack.zip"
echo "==> Building ${OUTPUT_ZIP} for NEMESIS Manager..."

rm -f "${OUTPUT_ZIP}"

python3 -c "
import zipfile, os

zipf = zipfile.ZipFile('${OUTPUT_ZIP}', 'w', zipfile.ZIP_DEFLATED)
targets = ['NEMESIS.data', 'bin', 'scripts', 'svc', 'hmgapi']

for target in targets:
    if os.path.isfile(target):
        zipf.write(target)
    elif os.path.isdir(target):
        for root, dirs, files in os.walk(target):
            for file in files:
                full_path = os.path.join(root, file)
                zipf.write(full_path, full_path)
zipf.close()
print('Successfully created ${OUTPUT_ZIP}')
"
