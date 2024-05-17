import gzip
from concurrent.futures import ProcessPoolExecutor
from functools import partial
from itertools import repeat
from pathlib import Path
from subprocess import run

from jinja2 import Environment, FileSystemLoader
from tqdm import tqdm

BASE_DIR = Path("/app")

FASTA_DIR = BASE_DIR / "fastas"
DB_DIR = BASE_DIR / "databases"
HTDOCS_DIR = BASE_DIR / "htdocs"
TEMPLATE_DIR = BASE_DIR / "templates"

CHUNK_SIZE = 1024 * 1024  # 1MB


def decompress_gzip_file(compressed_file: Path) -> Path:

    stripped_file_suffix = "".join(compressed_file.suffixes[:-1])

    uncompressed_file = compressed_file.with_suffix(stripped_file_suffix)

    with gzip.open(compressed_file, "rb") as f_in, open(
        uncompressed_file, "wb"
    ) as f_out:

        for chunk in iter(partial(f_in.read, CHUNK_SIZE), b""):
            f_out.write(chunk)

    return uncompressed_file


def create_blast_database(
    fasta_file: Path, database_name: str, decompress: bool = True
):

    if decompress:
        fasta_file = decompress_gzip_file(fasta_file)

    command_args = [
        "makeblastdb",
        "-dbtype",
        "nucl",
        "-in",
        str(fasta_file),
        "-out",
        str(DB_DIR / database_name),
        "-title",
        database_name,
    ]

    run(command_args, check=True)


def update_index_template(database_names: list[str]):

    env = Environment(loader=FileSystemLoader(TEMPLATE_DIR))
    template = env.get_template("index_template.html")
    html = template.render(databases=database_names)
    encode = html.encode("UTF-8")

    index_file = HTDOCS_DIR / "index.html"
    index_file.write_bytes(encode)

    # Save database list for parameter validation later
    database_list_file = TEMPLATE_DIR / "databases.txt"
    database_list_file.write_text("\n".join(database_names))


if __name__ == "__main__":

    # fastafiles = FASTA_DIR.glob("*.fa.gz")
    # with ProcessPoolExecutor(max_workers=4) as executor:
    #     executor.map(create_blast_database, fastafiles)

    fastafiles = list(FASTA_DIR.glob("*.fa"))

    database_names = [x.stem.split(".")[0] for x in fastafiles]

    print(fastafiles)
    list(tqdm(map(create_blast_database, fastafiles, database_names, repeat(False))))

    update_index_template(database_names)
