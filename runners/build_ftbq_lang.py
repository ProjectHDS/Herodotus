from pathlib import Path
from typing import Dict, List, Set
from dataclasses import dataclass, field
from loguru import logger
from tqdm import tqdm


@dataclass
class Config:
    ftbquests_path: Path = Path(".minecraft/config/ftbquests")
    zh_cn_path: Path = Path(".minecraft/resources/herodotus/lang/zh_cn.lang")
    en_us_path: Path = Path(".minecraft/resources/herodotus/lang/en_us.lang")

    should_replace_key_type_value: Set[str] = field(default_factory=lambda: {"title"})
    should_replace_key_type_array: Set[str] = field(default_factory=lambda: {"text"})
    should_replace_key_type_both: Set[str] = field(
        default_factory=lambda: {"description"}
    )


class FTBQuestsLocalizer:
    def __init__(self, config: Config):
        self.config = config
        self.content_dict: Dict[str, str] = {}
        self.snbt_files: List[Path] = []

        logger.remove()
        logger.add(lambda msg: tqdm.write(msg, end=""), colorize=True)
        logger.info("Initializing FTB Quests Localizer")

    def process_all(self) -> None:
        try:
            logger.info(f"Starting to process directory: {self.config.ftbquests_path}")

            self._collect_snbt_files(self.config.ftbquests_path)

            if not self.snbt_files:
                logger.warning("No .snbt files found to process")
                return

            logger.info(f"Found {len(self.snbt_files)} .snbt files to process")

            for file_path in tqdm(
                self.snbt_files, desc="Processing SNBT files", unit="file"
            ):
                self._read_snbt(file_path)

            logger.info("Starting to write language files")

            lang_files = [self.config.zh_cn_path, self.config.en_us_path]
            for lang_file in tqdm(
                lang_files, desc="Writing language files", unit="file"
            ):
                self._write_lang_file(lang_file)

            logger.success(
                f"Processing completed successfully! Processed {len(self.content_dict)} entries"
            )

        except Exception as e:
            logger.error(f"Error occurred during processing: {e}")
            raise

    def _collect_snbt_files(self, path: Path) -> None:
        if not path.exists():
            logger.warning(f"Directory does not exist: {path}")
            return

        all_files = list(path.rglob("*.snbt"))

        for file_path in tqdm(
            all_files, desc="Collecting SNBT files", unit="file", leave=False
        ):
            self.snbt_files.append(file_path)
            logger.debug(f"Collected SNBT file: {file_path}")

    def _read_snbt(self, file_path: Path) -> None:
        try:
            with file_path.open("r", encoding="utf-8") as f:
                lines = f.readlines()

            file_name = file_path.stem
            if file_name == "chapter":
                file_name = file_path.parent.name

            logger.debug(f"Processing file: {file_path}, using name: {file_name}")

            if len(lines) > 100:
                processed_lines = []
                for line in tqdm(
                    lines, desc=f"Processing {file_path.name}", unit="line", leave=False
                ):
                    processed_lines.append(line)
                modified_lines = self._process_lines(processed_lines, file_name)
            else:
                modified_lines = self._process_lines(lines, file_name)

            with file_path.open("w", encoding="utf-8") as f:
                f.writelines(modified_lines)

        except Exception as e:
            logger.error(f"Error processing file {file_path}: {e}")
            raise

    def _process_lines(self, lines: List[str], file_name: str) -> List[str]:
        result_lines = lines.copy()
        current_flag = "none"
        array_counter = 0

        for i, line in enumerate(lines):
            stripped_line = line.lstrip()

            if stripped_line.startswith("]"):
                current_flag = "none"
                array_counter = 0
                continue

            if current_flag != "none":
                array_counter += 1
                text_key = f"{current_flag}.{array_counter}"
                self._replace_with_lang_key(line, text_key, result_lines, i, file_name)
                continue

            for key in self.config.should_replace_key_type_value:
                if stripped_line.startswith(f"{key}:"):
                    self._replace_with_lang_key(line, key, result_lines, i, file_name)
                    break

            for key in self.config.should_replace_key_type_array:
                if stripped_line.startswith(f"{key}:"):
                    current_flag = key
                    array_counter = 0
                    break

            for key in self.config.should_replace_key_type_both:
                if stripped_line.startswith(f"{key}:"):
                    if line.rstrip().endswith("["):
                        current_flag = key
                        array_counter = 0
                    else:
                        self._replace_with_lang_key(
                            line, key, result_lines, i, file_name
                        )
                    break

        return result_lines

    def _replace_with_lang_key(
        self, line: str, key: str, lines: List[str], index: int, file_name: str
    ) -> None:
        try:
            first_quote = line.find('"')
            last_quote = line.rfind('"')

            if first_quote == -1 or last_quote == -1 or first_quote == last_quote:
                logger.warning(f"Cannot find quotes, skipping line: {line.strip()}")
                return

            head = line[:first_quote]
            content = line[first_quote + 1 : last_quote]
            tail = line[last_quote + 1 :]

            lang_key = f"herodotus.quests.{file_name}.{key}"

            logger.debug(f"Generated language key: {lang_key} = {content}")

            new_line = f'{head}"{{{lang_key}}}"{tail}'
            lines[index] = new_line
            self.content_dict[lang_key] = content

        except Exception as e:
            logger.error(
                f"Error replacing language key: {e}, line content: {line.strip()}"
            )

    def _write_lang_file(self, lang_path: Path) -> None:
        if not self.content_dict:
            logger.info("No content to write to language file")
            return

        try:
            lang_path.parent.mkdir(parents=True, exist_ok=True)

            if not lang_path.exists():
                lang_path.touch()
                logger.info(f"Created new language file: {lang_path}")

            existing_lines = []
            with lang_path.open("r", encoding="utf-8") as f:
                existing_lines = f.readlines()

            updated_lines = []
            remaining_content = self.content_dict.copy()

            lines_to_process = existing_lines
            if len(existing_lines) > 100:
                lines_to_process = tqdm(
                    existing_lines,
                    desc=f"Processing {lang_path.name}",
                    unit="line",
                    leave=False,
                )

            for line in lines_to_process:
                if line.startswith("#") or "=" not in line:
                    updated_lines.append(line)
                    continue

                key = line.split("=", 1)[0]
                if key in remaining_content:
                    value = remaining_content.pop(key)
                    if "{" not in value and "}" not in value:
                        updated_lines.append(f"{key}={value}\n")
                        logger.debug(f"Updated existing entry: {key}")
                    else:
                        updated_lines.append(line)
                else:
                    updated_lines.append(line)

            new_entries = []
            entries_to_add = list(remaining_content.items())
            if len(entries_to_add) > 50:
                entries_to_add = tqdm(
                    entries_to_add, desc="Adding new entries", unit="entry", leave=False
                )

            for key, value in entries_to_add:
                new_entries.append(f"{key}={value}\n")
                logger.debug(f"Added new entry: {key}")

            with lang_path.open("w", encoding="utf-8") as f:
                f.writelines(updated_lines)
                f.writelines(new_entries)

            logger.success(
                f"Successfully wrote language file: {lang_path}, "
                f"updated {len(self.content_dict) - len(remaining_content)} entries, "
                f"added {len(remaining_content)} new entries"
            )

        except Exception as e:
            logger.error(f"Error writing language file {lang_path}: {e}")
            raise


def main():
    config = Config()
    localizer = FTBQuestsLocalizer(config)
    localizer.process_all()


if __name__ == "__main__":
    main()
