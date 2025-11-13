import os
import sys
import argparse
import openslide
from PIL import Image
from openslide.deepzoom import DeepZoomGenerator

def converter(
    slide_path, 
    output_dir, 
    tile_size=1024,
    overlap=1, 
    tile_format="png"
):
    os.makedirs(output_dir, exist_ok=True)

    slide = openslide.OpenSlide(slide_path)
    print(f"Slide aberto: {slide_path}, dimensões: {slide.dimensions}")

    dz = DeepZoomGenerator(slide, tile_size=tile_size, overlap=overlap, limit_bounds=True)

    slide_name = os.path.splitext(os.path.basename(slide_path))[0]
    dzi_path = os.path.join(output_dir, f"{slide_name}.dzi")
    with open(dzi_path, "w") as f:
        f.write(dz.get_dzi(tile_format))
    print(f".dzi salvo: {dzi_path}")

    tiles_folder = os.path.join(output_dir, f"{slide_name}_files")
    os.makedirs(tiles_folder, exist_ok=True)

    print("Gerando imagens para o .dzi...")
    for level in range(dz.level_count):
        cols, rows = dz.level_tiles[level]
        level_folder = os.path.join(tiles_folder, str(level))
        os.makedirs(level_folder, exist_ok=True)
        total_tiles = cols * rows
        print(f"Nível {level}/{dz.level_count-1}: {cols} x {rows} ({total_tiles} total)")

        count = 0
        for col in range(cols):
            for row in range(rows):
                tile = dz.get_tile(level, (col, row))
                tile.save(os.path.join(level_folder, f"{col}_{row}.{tile_format}"))
                count += 1
                if count % 100 == 0:
                    print(f"> Progresso: {count}/{total_tiles}", end='\r')
        print(f"Nível {level} completo!\n> Progresso: {count}/{total_tiles}")

    print("Conversão completa!")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("input")
    parser.add_argument("output_dir")
    parser.add_argument("--tile_size", type=int, default=1024)
    parser.add_argument("--overlap", type=int, default=1)
    parser.add_argument("--format", default="png", choices=["png","jpeg","jpg"])
    args = parser.parse_args()

    if not os.path.exists(args.input):
        print(f"ERRO: Arquivo não encontrado: {args.input}", file=sys.stderr)
        sys.exit(2)
    if os.path.getsize(args.input) == 0:
        print(f"ERRO: Arquivo vazio (0 bytes): {args.input}", file=sys.stderr)
        sys.exit(3)

    try:
        converter(
            slide_path=args.input,
            output_dir=args.output_dir,
            tile_size=args.tile_size,
            overlap=args.overlap,
            tile_format=args.format
        )
    except Exception as e:
        print(f"ERRO: {type(e).__name__}: {e}", file=sys.stderr)
        sys.exit(1)
    print("SUCESSO!")
    sys.exit(0)
