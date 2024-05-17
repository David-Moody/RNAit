import asyncio
import logging
from pathlib import Path

import aiometer
import httpx
from tqdm import tqdm

RELEASE = "WBPS19"
BASE_URL = f"https://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/{RELEASE}"
FASTA_DIR = Path("./fastas")
FASTA_DIR.mkdir(exist_ok=True)

client = httpx.AsyncClient()


async def download_file(url: str):

    filename = url.split("/")[-1]

    with open(FASTA_DIR / filename, "wb") as f:
        async with client.stream("GET", url) as response:
            async for chunk in response.aiter_bytes():
                f.write(chunk)


async def download_all_cds_fastas():

    logging.info(f"Using release: {RELEASE}")

    # Checksum file provides all filepaths without needing to enumerate the directory structure
    r = await client.get(f"{BASE_URL}/CHECKSUMS")
    r.raise_for_status()

    checksum_file_contents = r.text.splitlines()

    filepaths = [line.split("  ")[-1] for line in checksum_file_contents]
    logging.info(f"{len(filepaths) = }")

    cds_paths = [
        f"{BASE_URL}/{path}"
        for path in filepaths
        if "CDS_transcripts" in path.split("/")[-1]
    ]
    logging.info(f"{len(cds_paths) = }")

    await aiometer.run_on_each(
        download_file,
        tqdm(cds_paths),  # type: ignore
        max_at_once=10,
        max_per_second=10,
    )


if __name__ == "__main__":
    # logging.getLogger().setLevel(logging.INFO)
    asyncio.run(download_all_cds_fastas())
