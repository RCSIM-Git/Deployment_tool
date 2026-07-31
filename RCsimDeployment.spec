import os
import sys
from PyInstaller.utils.hooks import collect_all

# Get paths
spec_dir = os.path.dirname(os.path.abspath(SPEC))
project_root = os.path.abspath(os.path.join(spec_dir, ".."))

datas = [('ui/locales', 'ui/locales'), ('web', 'web')]
binaries = []
hiddenimports = ['paramiko']

# Collect all for paramiko and dependencies
for pkg in ['paramiko', 'cryptography', 'nacl']:
    tmp_ret = collect_all(pkg)
    datas += tmp_ret[0]
    binaries += tmp_ret[1]
    hiddenimports += tmp_ret[2]

a = Analysis(
    ['RCsimRPi5deploymentapp.py'],
    pathex=[spec_dir],
    binaries=binaries,
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=['pytest', 'unittest', 'datasets', 'pyarrow', 'transformers', 'fsspec', 'huggingface_hub', 'timm', 'gradio', 'bitsandbytes', 'tensorboard', 'tensorflow', 'boto3', 'botocore', 's3transfer', 'google.cloud', 'google.cloud.storage', 'grpc', 'wandb', 'accelerate'],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='RCsimDeployment',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
