import argparse
from pathlib import Path
from minijinja import Environment


def to_unix_path(path: str):
    return str(Path(path).as_posix()) if path else ""


TEMPLATE = """# Configuration file
general {
    # Use this to enable multi-part download [default: true]
    B:"Enable Multi-part Download"={{ enable_multipart_download | default(true) | lower }}

    # Args for Java 21 jvm [default: -Xmx4g -Xms4g]
    S:"JVM Arguments"={{ jvm_arguments | default("-Xmx4g -Xms4g") }}

    # Path to javaw.exe or java binary [default: java]
    S:"Java Path"={{ java_path | default("java") | to_unix_path }}

    # Library path, you may point it to launcher's library path for re-using, empty for default relauncher/ [default: ]
    S:"Library Path"={{ library_path | default("") | to_unix_path }}

    # Proxy address [default: ]
    S:"Proxy Address"={{ proxy_address | default("") }}

    # Proxy Port [range: 0 ~ 65535, default: 0]
    I:"Proxy Port"={{ proxy_port | default(0) }}

    # Put library files under directory of their group name [default: true]
    B:"Respect Library Structure"={{ respect_library_structure | default(true) | lower }}

    # Search for relauncher/Cleanroom-MMC-instance-*.zip and install from there [default: true]
    B:"Use Local MMC Pack"={{ use_local_mmc_pack | default(false) | lower }}
}"""


def main():
    parser = argparse.ArgumentParser(
        description="Generate Minecraft configuration file"
    )

    parser.add_argument(
        "--jvm-args",
        default="",
        help="JVM arguments (default: -Xmx4g -Xms4g)",
    )
    parser.add_argument(
        "--java-path", default="java", help="Path to Java binary (default: java)"
    )
    parser.add_argument(
        "--library-path", default="", help="Library path (default: empty)"
    )
    parser.add_argument(
        "--proxy-address", default="", help="Proxy address (default: empty)"
    )
    parser.add_argument(
        "--proxy-port", type=int, default=0, help="Proxy port (default: 0)"
    )
    parser.add_argument(
        "--enable-multipart",
        action="store_true",
        default=True,
        help="Enable multi-part download (default: True)",
    )
    parser.add_argument(
        "--disable-multipart", action="store_true", help="Disable multi-part download"
    )
    parser.add_argument(
        "--respect-structure",
        action="store_true",
        default=True,
        help="Respect library structure (default: True)",
    )
    parser.add_argument(
        "--no-respect-structure",
        action="store_true",
        help="Do not respect library structure",
    )
    parser.add_argument(
        "--use-local-mmc",
        action="store_true",
        help="Use local MMC pack (default: False)",
    )
    parser.add_argument(
        "-o",
        "--output",
        default="./gml/.minecraft/config/cleanroom_relauncher.cfg",
        help="Output file path (default: config.cfg)",
    )

    args = parser.parse_args()

    enable_multipart = (
        not args.disable_multipart if args.disable_multipart else args.enable_multipart
    )
    respect_structure = (
        not args.no_respect_structure
        if args.no_respect_structure
        else args.respect_structure
    )

    context = {
        "jvm_arguments": args.jvm_args,
        "java_path": args.java_path,
        "library_path": args.library_path,
        "proxy_address": args.proxy_address,
        "proxy_port": args.proxy_port,
        "enable_multipart_download": enable_multipart,
        "respect_library_structure": respect_structure,
        "use_local_mmc_pack": args.use_local_mmc,
    }

    # 渲染模板
    env = Environment()
    env.add_filter("to_unix_path", to_unix_path)  # type: ignore
    env.add_template("relauncher", TEMPLATE)
    result = env.render_template("relauncher", **context)

    # 输出结果
    if args.output == "-":
        print(result)
    else:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(result)
        print(f"Configuration saved to {args.output}")


if __name__ == "__main__":
    main()
