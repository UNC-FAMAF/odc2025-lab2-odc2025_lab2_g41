from PIL import Image

def extract_colors_and_recolor(
    image_path: str,
    output_path: str,
    n_colors: int = 16
) -> list[str]:
    """
1) Extrae los `n_colors` colores más frecuentes (HEX).
2) Crea una copia de la imagen usando exclusivamente esa paleta.
3) Guarda la copia en `output_path`.

Devuelve la lista de colores.
    """
    # ── Abrir y cuantizar ──────────────────────────────────────────────────────
    img = Image.open(image_path).convert("RGB")
    quant = img.convert("P", palette=Image.ADAPTIVE, colors=n_colors)

    # ── Paleta predominante ───────────────────────────────────────────────────
    palette = quant.getpalette()
    counts  = sorted(quant.getcolors(), reverse=True)   # [(reps, idx), …]

    hex_colors = []
    for _, idx in counts[:n_colors]:
        r, g, b = palette[idx*3 : idx*3 + 3]
        hex_colors.append(f"#{r:02x}{g:02x}{b:02x}")

    # ── Generar imagen recolorizada ───────────────────────────────────────────
    recolored = quant.convert("RGB")
    recolored.save(output_path)

    return hex_colors


if __name__ == "__main__":
    colors = extract_colors_and_recolor(
        "/home/mateo/odc2025-lab2-odc2025_lab2_g41/utils/PixelArt.jpeg",
        "/home/mateo/odc2025-lab2-odc2025_lab2_g41/utils/PixelArt_.jpeg"
    )
    print("Paleta extraída:", colors)
