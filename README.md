# `spacelab`

### 🔬 A ready-to-use Docker image packed with digital forensics tools

## Example usage

Start an interactive session with the current directory's `data` folder mounted inside the container:

```bash
docker run --rm -it \
  -v "$(pwd)/data:/lab/data" \
  kkrypt0nn/spacelab
```

Your local `data` directory will be available at `/lab/data` inside the container. Once inside the container, use any of the included tools against your evidence files.

## Contributing

Contributions are more than welcome while following the [Contributing Guidelines](./CONTRIBUTING.md).

## Included Tools

### Disk & File System Forensics

- [`dcfldd`](https://dcfldd.sourceforge.net/) - Version `1.9.3-2` <!-- renovate: datasource=deb depName=dcfldd -->
- [`Foremost`](https://foremost.sourceforge.net/) - Version `1.5.7-11build1` <!-- renovate: datasource=deb depName=foremost -->
- [`The Sleuth Kit`](https://www.sleuthkit.org/) - Version `4.12.1+dfsg-3build1` <!-- renovate: datasource=deb depName=sleuthkit -->
- [`TestDisk & PhotoRec`](https://www.cgsecurity.org/) - Version `7.2-0.1build1` <!-- renovate: datasource=deb depName=testdisk -->
- [`Scalpel`](https://github.com/sleuthkit/scalpel) - Version `1.60+git20240110.6960eb2-2build1` <!-- renovate: datasource=deb depName=scalpel -->

### Memory Forensics

- [`Volatility 3`](https://github.com/volatilityfoundation/volatility3) - Version `2.28.2` <!-- renovate: datasource=github-tags depName=volatilityfoundation/volatility3 -->

### File (& Malware) Analysis

- [`binwalk`](https://github.com/refirmlabs/binwalk) - Version `3.1.0` <!-- renovate: datasource=github-tags depName=ReFirmLabs/binwalk -->
- [`YARA`](https://virustotal.github.io/yara/) - Version `4.5.5-1` <!-- renovate: datasource=deb depName=yara -->
- [`YARA-X`](https://github.com/VirusTotal/yara-x) - Version `1.24.0` <!-- renovate: datasource=github-tags depName=VirusTotal/yara-x -->

### Log Analysis & Incident Response

- [`Hayabusa`](https://github.com/Yamato-Security/hayabusa) - Version `4.4.0` <!-- renovate: datasource=github-tags depName=Yamato-Security/hayabusa -->

## Disclaimer

This image is intended for legitimate digital forensics, incident response, and security research purposes. Always ensure you have proper authorization before analyzing data or systems that you do not own.
