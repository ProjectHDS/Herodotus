from pathlib import Path
import shutil

src_root = Path(".") / ".minecraft"
dst_root = Path(".") / "gml" / ".Minecraft"
dst_root.mkdir(parents=True, exist_ok=True)

for file in src_root.rglob("*"):
    if file.is_file():
        rel_path = file.relative_to(src_root)
        dest_file = dst_root / rel_path
        dest_file.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(str(file), str(dest_file))
        # print(f"Moved: {file} -> {dest_file}")
