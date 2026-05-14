# 1. Imagine you have a memory dump from a potentially compromised Windows machine (system.dmp):

## 1. Place the memory dump in your evidence directory
cp system.dmp ~/digital-detective/evidence/

## 2. Launch the container
cd docker/digital-detective
./deploy_digital_detective_docker.sh

## 3. Inside the container, analyze the memory dump
volatility -f /mnt/evidence/system.dmp windows.pslist
volatility -f /mnt/evidence/system.dmp windows.netscan

## 4. Check for suspicious processes with YARA
yara /mnt/tools/malware_signatures.yar /mnt/evidence/system.dmp

## 5. Export findings to the host for reporting
cp analysis_results.txt /mnt/output/

The results stay in ~/digital-detective/output/ after the container exits, ready for your incident report. This keeps your forensics tools isolated and prevents accidental contamination of your system environment.

# 2. Suppose you have a forensic image of a suspect's hard drive (drive_image.dd) and need to recover deleted files and analyze filesystem artifacts:

# 1. Copy the disk image to evidence directory
cp drive_image.dd ~/digital-detective/evidence/

# 2. Launch the container
cd docker/digital-detective
./deploy_digital_detective_docker.sh

# 3. Analyze the disk image with The Sleuth Kit
fsstat /mnt/evidence/drive_image.dd
istat /mnt/evidence/drive_image.dd -f ntfs 12345

# 4. List deleted inodes to recover files
ils /mnt/evidence/drive_image.dd | grep "d/d"

# 5. Extract specific deleted files
icat /mnt/evidence/drive_image.dd -f ntfs 54321 > /mnt/output/recovered_file.txt

# 6. Use YARA to scan recovered files for malware signatures
yara /mnt/tools/apt_signatures.yar /mnt/output/recovered_file.txt

# 7. Analyze any binary executables with Python
```
python3 << 'EOF'
import capstone
with open('/mnt/output/suspicious.exe', 'rb') as f:
    code = f.read()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_64)
    for i in md.disasm(code, 0x1000):
        print(f"0x{i.address:x}:\t{i.mnemonic}\t{i.op_str}")
EOF
```
This scenario demonstrates disk forensics and binary analysis — recovering hidden evidence from storage media and examining executable files for suspicious behavior. Perfect for incident response, legal cases, or security research.