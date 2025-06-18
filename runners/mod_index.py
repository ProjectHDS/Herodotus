import re
import rtoml
from pathlib import Path
from typing import Dict, Any, Optional, Union, IO
from dataclasses import dataclass, field


@dataclass
class ModDownload:
    """Specifies how to download the mod file"""

    url: str = ""
    hash_format: str = ""
    hash: str = ""
    mode: str = ""  # Defaults to "url"

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "ModDownload":
        return cls(
            url=data.get("url", ""),
            hash_format=data.get("hash-format", ""),
            hash=data.get("hash", ""),
            mode=data.get("mode", ""),
        )


@dataclass
class ModOption:
    """Specifies optional metadata for this mod file"""

    optional: bool = False
    description: str = ""
    default: bool = False

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "ModOption":
        return cls(
            optional=data.get("optional", False),
            description=data.get("description", ""),
            default=data.get("default", False),
        )


@dataclass
class Mod:
    """Stores metadata about a mod. This is written to a TOML file for each mod."""

    name: str = ""
    filename: str = ""
    side: str = ""  # "server", "client", "both", or ""
    pin: bool = False
    download: ModDownload = field(default_factory=ModDownload)
    update: Dict[str, Dict[str, Any]] = field(default_factory=dict)
    option: Optional[ModOption] = None

    # Internal fields
    meta_file: str = field(default="", init=False)
    update_data: Dict[str, Any] = field(default_factory=dict, init=False)

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "Mod":
        """Create Mod instance from dictionary (typically from rtoml.load)"""
        mod = cls(
            name=data.get("name", ""),
            filename=data.get("filename", ""),
            side=data.get("side", ""),
            pin=data.get("pin", False),
            download=ModDownload.from_dict(data.get("download", {})),
            update=data.get("update", {}),
        )

        # Handle optional field
        if "option" in data:
            mod.option = ModOption.from_dict(data["option"])

        return mod

    def set_meta_path(self, meta_file: str) -> str:
        """Set the file path of a metadata file"""
        self.meta_file = meta_file
        return self.meta_file

    def get_file_path(self) -> str:
        """Get the metadata file path"""
        return self.meta_file

    def get_dest_file_path(self) -> str:
        """Get the destination file path of the mod"""
        if self.meta_file:
            return str(Path(self.meta_file).parent / self.filename)
        return self.filename


# Constants for mod sides
class ModSide:
    SERVER = "server"
    CLIENT = "client"
    UNIVERSAL = "both"
    EMPTY = ""


# Constants for download modes
class DownloadMode:
    URL = "url"
    CURSEFORGE = "metadata:curseforge"


def load_mod(mod_file: Union[str, Path]) -> Mod:
    """Load a mod file from a path using rtoml"""
    try:
        # Normalize the path to handle mixed separators
        normalized_path = Path(mod_file).resolve()

        # Use Path.read_text() to ensure proper file handling
        with open(normalized_path, "r", encoding="utf-8") as f:
            data = rtoml.load(f)

        mod = Mod.from_dict(data)
        mod.set_meta_path(str(normalized_path))
        return mod
    except Exception as e:
        raise RuntimeError(f"Failed to load mod file {mod_file}: {e}")


def slugify_name(name: str) -> str:
    """Convert a mod name to a slug (filename-friendly format)"""
    # Convert to lowercase
    lower = name.lower()

    # Remove content in parentheses
    no_brackets = re.sub(r"\(.*\)", "", lower)

    # Remove suffix after " - "
    no_suffix = re.sub(r" - .+", "", no_brackets)

    # Replace non-alphanumeric characters with dashes
    limited_chars = re.sub(r"[^a-z\d]", "-", no_suffix)

    # Replace multiple consecutive dashes with single dash
    no_duplicate_dashes = re.sub(r"-+", "-", limited_chars)

    # Remove leading and trailing dashes
    no_leading_trailing_dashes = re.sub(r"^-|-$", "", no_duplicate_dashes)

    return no_leading_trailing_dashes
