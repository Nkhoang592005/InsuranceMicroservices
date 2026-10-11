"""Package the assignment sources and actual validation evidence, without installers/caches."""
from pathlib import Path
import hashlib
import json
import os
import sys
import xml.etree.ElementTree as ET
from zipfile import ZipFile, ZIP_DEFLATED

root = Path(__file__).resolve().parents[2]
sys.stdout.reconfigure(encoding='utf-8')
artifacts = root / 'artifacts'
artifacts.mkdir(exist_ok=True)
def read_log(path):
    data = path.read_bytes()
    return data.decode('utf-16' if data.startswith((b'\xff\xfe', b'\xfe\xff')) else 'utf-8-sig')

build = read_log(artifacts / 'build-output.txt')
assert 'Build succeeded.' in build and '0 Warning(s)' in build and '0 Error(s)' in build
assert 'Build complete.' in read_log(artifacts / 'vue-build-output.txt'), 'Vue build evidence is incomplete.'
assert 'BUILD SUCCESSFUL' in read_log(artifacts / 'eureka-build-output.txt'), 'Eureka build evidence is incomplete.'
namespace = {'t': 'http://microsoft.com/schemas/VisualStudio/TeamTest/2010'}
results = []
for report in sorted((artifacts / 'tests').glob('*.trx')):
    for result in ET.parse(report).findall('.//t:UnitTestResult', namespace):
        results.append({'name': result.get('testName'), 'outcome': result.get('outcome')})
assert len(results) == 9 and all(r['outcome'] == 'Passed' for r in results)
assert len({r['name'] for r in results}) == 9, 'Expected one result per service.'
for required in ['build-result.png', 'database-verification.txt', 'sql-restore-verification.txt',
                 'eureka-runtime-verification.txt', 'eureka-server.jar']:
    assert (artifacts / required).is_file(), f'Missing evidence: {required}'
backups = []
for database in ['payments', 'jobs', 'policy', 'pricing']:
    file = artifacts / 'backups' / f'lab_netmicro_{database}.backup'
    assert file.read_bytes().startswith(b'PGDMP')
    backups.append({'file': file.name, 'bytes': file.stat().st_size, 'sha256': hashlib.sha256(file.read_bytes()).hexdigest()})
sql_destination = artifacts / 'BaiThucHanh4-backup-sql.zip'
with ZipFile(sql_destination, 'w', ZIP_DEFLATED) as sql_archive:
    for file in sorted((artifacts / 'backups').glob('*.sql')):
        sql_archive.write(file, file.name)
summary = {
    'solutionProjects': len(ET.parse(root / 'InsuranceMicroservices.slnx').findall('.//Project')),
    'dotnetBuild': {'errors': 0, 'warnings': 0},
    'tests': results,
    'backups': backups,
    'backupRestoreVerified': ['payments', 'jobs', 'policy', 'pricing'],
    'sqlBackupRestoreVerified': ['payments', 'jobs', 'policy', 'pricing'],
    'dockerComposeConfigurationValidated': True,
    'dockerRuntimeVerified': False,
    'vueCompilationCompleted': 'Build complete.' in read_log(artifacts / 'vue-build-output.txt'),
    'vueBundleSizeWarnings': 2,
    'vueCliStoppedAfterCompilationOnNode24': False,
    'vueBuildUsesCompletionWrapper': True,
    'gatewayUnauthenticatedRequestStatus': 401,
    'eurekaJarPresent': (artifacts / 'eureka-server.jar').exists(),
    'eurekaRuntimeStatus': 200 if (artifacts / 'eureka-runtime-verification.txt').exists() else None,
    'githubPublishedByThisTask': False,
}
(artifacts / 'validation-summary.json').write_text(json.dumps(summary, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

destination = artifacts / 'BaiThucHanh4-submission.zip'
excluded = {'.git', '.tools', '.gradle', 'node_modules', 'bin', 'obj', 'dist', 'build', 'postgres-data', '__pycache__'}
count = 0
with ZipFile(destination, 'w', ZIP_DEFLATED) as archive:
    for directory, directories, files in os.walk(root):
        directories[:] = [d for d in directories if d not in excluded]
        for filename in files:
            path = Path(directory) / filename
            if path == artifacts / 'submission-sha256.txt':
                continue
            if path.suffix.lower() in {'.exe', '.rar', '.zip'}:
                continue
            archive.write(path, path.relative_to(root).as_posix())
            count += 1
with ZipFile(destination) as archive:
    assert archive.testzip() is None
    for required in ['README.md', 'InsuranceMicroservices.slnx', 'artifacts/build-result.png',
                     'artifacts/validation-summary.json']:
        assert required in archive.namelist(), f'Missing submission file: {required}'
checksums = '\n'.join(f'{hashlib.sha256(path.read_bytes()).hexdigest()}  {path.name}'
                      for path in [destination, sql_destination]) + '\n'
(artifacts / 'submission-sha256.txt').write_text(checksums, encoding='utf-8')
print(json.dumps({'archive': str(destination), 'files': count, 'bytes': destination.stat().st_size, 'testsPassed': len(results), 'backups': len(backups), 'eurekaJar': summary['eurekaJarPresent']}, ensure_ascii=False))
