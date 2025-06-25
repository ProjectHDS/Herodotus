import asyncio
import httpx
import shutil
from loguru import logger
from pathlib import Path
from typing import Optional, Dict, Any, Tuple
from tqdm import tqdm

from mod_index import Mod

logger.remove()
logger.add(lambda msg: tqdm.write(msg, end=""), colorize=True)


class CurseForgeDownloader:
    """CurseForge mod downloader using httpx and loguru"""

    def __init__(
        self,
        api_key: str,
        cache_dir: Path,
        base_url: str = "https://api.curseforge.com",
    ):
        self.api_key = api_key
        self.base_url = base_url
        self.cache_dir = cache_dir
        self.client: Optional[httpx.AsyncClient] = None

    async def __aenter__(self) -> "CurseForgeDownloader":
        """Async context manager entry"""
        headers = {
            "x-api-key": self.api_key,
            "Accept": "application/json",
            "User-Agent": "Python-CurseForge-Downloader/2.0",
        }

        limits = httpx.Limits(max_keepalive_connections=20, max_connections=100)
        timeout = httpx.Timeout(30.0, connect=10.0)

        self.client = httpx.AsyncClient(
            base_url=self.base_url,
            headers=headers,
            limits=limits,
            timeout=timeout,
            follow_redirects=True,
        )
        return self

    async def __aexit__(self, exc_type, exc_val, exc_tb):
        """Async context manager exit"""
        if self.client:
            await self.client.aclose()

    async def get_mod_info(self, project_id: int) -> Optional[Dict[str, Any]]:
        """Get mod information from CurseForge API"""
        try:
            response = await self.client.get(f"/v1/mods/{project_id}")  # type: ignore
            response.raise_for_status()
            data = response.json()
            return data.get("data")
        except httpx.HTTPStatusError as e:
            logger.error(
                f"HTTP error getting mod info for project {project_id}: {e.response.status_code}"
            )
            return None
        except Exception as e:
            logger.error(f"Error getting mod info for project {project_id}: {e}")
            return None

    async def get_download_url(self, project_id: int, file_id: int) -> Optional[str]:
        """Get download URL for a specific mod file"""
        try:
            response = await self.client.get(  # type: ignore
                f"/v1/mods/{project_id}/files/{file_id}/download-url"
            )
            response.raise_for_status()
            data = response.json()
            return data.get("data")
        except httpx.HTTPStatusError as e:
            logger.error(
                f"HTTP error getting download URL for {project_id}/{file_id}: {e.response.status_code}"
            )
            return None
        except Exception as e:
            logger.error(f"Error getting download URL for {project_id}/{file_id}: {e}")
            return None

    def get_cache_file_path(self, hash_format: str, hash_value: str) -> Optional[Path]:
        """Generate cache file path from hash format and value"""
        if not hash_format or not hash_value:
            return None
        return self.cache_dir / f"{hash_format}_{hash_value}"

    def check_cache(self, hash_format: str, hash_value: str) -> Optional[Path]:
        """Check if file exists in cache and return path if found"""
        if not hash_format or not hash_value:
            return None

        cache_path = self.get_cache_file_path(hash_format, hash_value)
        if cache_path and cache_path.exists():
            return cache_path
        return None

    def save_to_cache(self, file_path: Path, hash_format: str, hash_value: str) -> bool:
        """Save a file to the cache directory"""
        if not hash_format or not hash_value:
            return False

        try:
            cache_path = self.get_cache_file_path(hash_format, hash_value)
            if not cache_path:
                return False

            # Make sure cache directory exists
            self.cache_dir.mkdir(parents=True, exist_ok=True)

            # Copy file to cache if it doesn't already exist there
            if not cache_path.exists():
                shutil.copy2(file_path, cache_path)
                logger.debug(f"Saved to cache: {cache_path.name}")
            return True
        except Exception as e:
            logger.error(f"Error saving to cache: {e}")
            return False

    async def download_file(self, url: str, file_path: Path) -> bool:
        """Download a single file"""
        try:
            async with self.client.stream("GET", url) as response:  # type: ignore
                response.raise_for_status()

                with open(file_path, "wb") as f:
                    async for chunk in response.aiter_bytes():
                        f.write(chunk)

                return True
        except httpx.HTTPStatusError as e:
            logger.error(f"HTTP error downloading {url}: {e.response.status_code}")
            return False
        except Exception as e:
            logger.error(f"Error downloading {url}: {e}")
            return False

    async def download_single_mod(
        self, mod: Mod, folder: Path, semaphore: asyncio.Semaphore, pbar: tqdm
    ) -> bool:
        """
        Download a single mod from Mod object
        """
        async with semaphore:
            try:
                # Get CurseForge info from mod's update data
                curseforge_data = mod.update.get("curseforge", {})
                if not curseforge_data:
                    logger.warning(f"No CurseForge data found for mod: {mod.name}")
                    pbar.set_postfix_str(f"⚠ {mod.name} (no CF data)")
                    pbar.update(1)
                    return False

                project_id = curseforge_data.get("project-id")
                file_id = curseforge_data.get("file-id")

                if not project_id or not file_id:
                    logger.warning(f"Missing project-id or file-id for mod: {mod.name}")
                    pbar.set_postfix_str(f"⚠ {mod.name} (missing IDs)")
                    pbar.update(1)
                    return False

                # Use the filename from mod object
                file_path = folder / mod.filename

                # Skip if file already exists
                if file_path.exists():
                    logger.info(f"File already exists, skipping: {mod.filename}")
                    pbar.set_postfix_str(f"⏭ {mod.filename}")
                    pbar.update(1)
                    return True

                # Check if file exists in cache
                hash_format = mod.download.hash_format
                hash_value = mod.download.hash

                if hash_format and hash_value:
                    cache_file = self.check_cache(hash_format, hash_value)
                    if cache_file:
                        # Copy from cache instead of downloading
                        logger.info(f"Found in cache, copying: {mod.filename}")
                        pbar.set_postfix_str(f"🔄 {mod.filename} (from cache)")

                        try:
                            shutil.copy2(cache_file, file_path)
                            pbar.set_postfix_str(f"✓ {mod.filename} (cached)")
                            logger.success(f"Copied from cache: {mod.name}")
                            pbar.update(1)
                            return True
                        except Exception as e:
                            logger.error(f"Error copying from cache: {e}")
                            # Fall through to normal download if cache copy fails

                pbar.set_postfix_str(f"📡 {mod.name}")
                logger.info(f"Getting download info for: {mod.name}")

                # Get download URL
                download_url = await self.get_download_url(project_id, file_id)
                if not download_url:
                    pbar.set_postfix_str(f"✗ {mod.name} (no URL)")
                    pbar.update(1)
                    return False

                pbar.set_postfix_str(f"⬇ {mod.filename}")
                logger.info(f"Downloading: {mod.name} -> {mod.filename}")

                # Download the file
                success = await self.download_file(download_url, file_path)

                if success:
                    pbar.set_postfix_str(f"✓ {mod.filename}")
                    logger.success(f"Downloaded: {mod.name}")

                    # Save to cache if download was successful
                    if hash_format and hash_value:
                        self.save_to_cache(file_path, hash_format, hash_value)
                else:
                    pbar.set_postfix_str(f"✗ {mod.filename}")

                # Rate limiting - be nice to the API
                await asyncio.sleep(0.1)

                pbar.update(1)
                return success

            except Exception as e:
                logger.error(f"Error downloading mod {mod.name}: {e}")
                pbar.set_postfix_str(f"✗ {mod.name} (error)")
                pbar.update(1)
                return False


async def download_mods_from_list(
    mods: list[Mod],
    api_key: str,
    download_directory: str,
    max_concurrent: int = 8,
    blacklist: Optional[list[int]] = None,
    cache_directory: str = "./download_cache",
) -> bool:
    """
    Download mods from a list of Mod objects

    Args:
        mods: List of Mod objects to download
        api_key: CurseForge API key
        download_directory: Directory to save downloaded mods
        max_concurrent: Maximum number of concurrent downloads
        blacklist: List of project IDs to skip
        cache_directory: Directory to use for download cache (defaults to ./download_cache)
    """

    if not api_key:
        logger.error("API key cannot be null!")
        return False

    if not mods:
        logger.warning("No mods provided for download")
        return True

    # Setup paths
    folder = Path(download_directory)
    folder.mkdir(parents=True, exist_ok=True)
    logger.info(f"Mods folder: {folder.absolute()}")

    # Setup cache directory
    cache_dir = Path(cache_directory)
    cache_dir.mkdir(parents=True, exist_ok=True)
    logger.info(f"Cache directory: {cache_dir.absolute()}")

    # Filter mods that have CurseForge data and are not blacklisted
    blacklist_set = set(blacklist or [])
    downloadable_mods = []

    for mod in mods:
        curseforge_data = mod.update.get("curseforge", {})
        if not curseforge_data:
            logger.debug(f"Skipping {mod.name}: No CurseForge data")
            continue

        project_id = curseforge_data.get("project-id")
        if project_id in blacklist_set:
            logger.info(f"Skipping {mod.name}: Blacklisted (ID: {project_id})")
            continue

        downloadable_mods.append(mod)

    logger.info(
        f"Found {len(downloadable_mods)} mods to download (from {len(mods)} total)"
    )

    if not downloadable_mods:
        logger.warning("No mods available for download")
        return True

    # Download mods with progress bar
    semaphore = asyncio.Semaphore(max_concurrent)
    success_count = 0

    async with CurseForgeDownloader(api_key, cache_dir) as downloader:
        with tqdm(
            total=len(downloadable_mods),
            desc="Downloading mods",
            unit="mod",
            ncols=120,
            bar_format="{l_bar}{bar}| {n_fmt}/{total_fmt} [{elapsed}<{remaining}, {rate_fmt}] {postfix}",
            disable=None,
        ) as pbar:
            logger.info("Starting downloads...")

            tasks = [
                downloader.download_single_mod(mod, folder, semaphore, pbar)
                for mod in downloadable_mods
            ]

            results = await asyncio.gather(*tasks, return_exceptions=True)

            # Count successful downloads
            success_count = sum(
                1 for result in results if isinstance(result, bool) and result
            )

            # Log any exceptions
            for i, result in enumerate(results):
                if isinstance(result, Exception):
                    logger.error(
                        f"Exception downloading {downloadable_mods[i].name}: {result}"
                    )

    logger.info(
        f"Download completed: {success_count}/{len(downloadable_mods)} successful"
    )

    if success_count == len(downloadable_mods):
        logger.success("All mods downloaded successfully!")
        return True
    else:
        logger.warning(
            f"Some downloads failed: {len(downloadable_mods) - success_count} failed"
        )
        return False
