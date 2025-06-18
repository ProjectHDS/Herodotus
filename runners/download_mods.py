import asyncio
from glob import glob
import sys

from loguru import logger

from mod_index import Mod, load_mod
from mod_downloader import download_mods_from_list


def collect_mods_from_index(index_directory: str, filter: str):
    mods: list[Mod] = []
    for file in glob(f"{index_directory}/*.toml"):
        mod = load_mod(file)
        if filter == mod.side or mod.side == "both":
            mods.append(mod)
    return mods


async def main():
    cf_token = sys.argv[1]
    download_directory = sys.argv[2]
    index_directory = sys.argv[3]
    side = sys.argv[4]
    black_list = [int(x) for x in sys.argv[5].split(",")]
    mods = collect_mods_from_index(index_directory, side)
    success = await download_mods_from_list(
        mods=mods,
        api_key=cf_token,
        download_directory=download_directory,
        max_concurrent=16,
        blacklist=black_list,
    )
    if success:
        logger.success("Mod downloaded.")


if __name__ == "__main__":
    asyncio.run(main())
