shader_type canvas_item;

// ============================================================
// NASTAVENÍ
// ============================================================

// Rychlost pohybu vln
uniform float wave_speed : hint_range(0.0, 2.0) = 0.85;

// Velikost / hustota vln
uniform float wave_scale : hint_range(0.005, 0.1) = 0.1;

// Síla deformace vln
uniform float distortion : hint_range(0.0, 2.0) = 2.0;

// Síla výsledného efektu
uniform float wave_strength : hint_range(0.0, 1.0) = 0.115;

// Tyrkysová barva odlesků
uniform vec4 wave_color : source_color = vec4(
    0.25,
    0.85,
    0.95,
    1.0
);


// ============================================================
// WORLD POSITION
// ============================================================
//
// Toto je nejdůležitější část.
//
// Nepoužíváme UV pro animaci.
// Používáme skutečnou pozici ve světě.
//
// Díky tomu shader neví nic o hranicích 64x64 tile.
// Vlny proto pokračují plynule přes všechny tiles.
// ============================================================

varying vec2 world_position;

void vertex()
{
    world_position =
        (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}


// ============================================================
// HASH
// ============================================================

float hash(vec2 p)
{
    p = fract(
        p * vec2(
            123.34,
            456.21
        )
    );

    p += dot(
        p,
        p + 45.32
    );

    return fract(
        p.x * p.y
    );
}


// ============================================================
// VALUE NOISE
// ============================================================

float noise(vec2 p)
{
    vec2 i = floor(p);
    vec2 f = fract(p);

    // Smooth interpolation
    f = f * f * (
        3.0 - 2.0 * f
    );

    float a = hash(i);

    float b = hash(
        i + vec2(1.0, 0.0)
    );

    float c = hash(
        i + vec2(0.0, 1.0)
    );

    float d = hash(
        i + vec2(1.0, 1.0)
    );

    return mix(
        mix(a, b, f.x),
        mix(c, d, f.x),
        f.y
    );
}


// ============================================================
// FBM
// ============================================================
//
// Více vrstev šumu vytvoří organičtější pohyb vody.
// ============================================================

float fbm(vec2 p)
{
    float value = 0.0;

    float amplitude = 0.5;

    for (int i = 0; i < 5; i++)
    {
        value +=
            noise(p) *
            amplitude;

        p *= 2.0;

        amplitude *= 0.5;
    }

    return value;
}


// ============================================================
// WATER RIPPLE
// ============================================================
//
// Vytvoří nepravidelnou síť vodních vlnek.
// ============================================================

float water_ripples(vec2 p)
{
    // Velká pomalá deformace
    float large_noise =
        fbm(
            p * 0.65
        );

    // Menší deformace
    float small_noise =
        fbm(
            p * 1.8
        );

    // Pohyb první vrstvy
    float moving_noise =
        fbm(
            p * 1.25 +
            vec2(
                TIME * wave_speed,
                -TIME * wave_speed * 0.55
            )
        );

    // Deformujeme prostor
    p +=
        (large_noise - 0.5) *
        distortion;

    p +=
        (small_noise - 0.5) *
        distortion *
        0.35;


    // --------------------------------------------------------
    // VLNA 1
    // --------------------------------------------------------

    float wave1 =
        sin(
            p.x * 3.8 +
            p.y * 1.4 +
            moving_noise * 4.0
        );


    // --------------------------------------------------------
    // VLNA 2
    // --------------------------------------------------------

    float wave2 =
        sin(
            p.y * 4.5 -
            p.x * 1.7 +
            large_noise * 5.0
        );


    // --------------------------------------------------------
    // VLNA 3
    // --------------------------------------------------------

    float wave3 =
        sin(
            (p.x + p.y) * 3.0 +
            small_noise * 4.0
        );


    // Kombinace
    float result =
        wave1 * 0.50 +
        wave2 * 0.30 +
        wave3 * 0.20;


    return result;
}


// ============================================================
// FRAGMENT
// ============================================================

void fragment()
{
    // Původní textura vody
    vec4 base_color =
        texture(
            TEXTURE,
            UV
        );


    // ========================================================
    // WORLD SPACE
    // ========================================================
    //
    // Používáme skutečné pixely ve světě.
    //
    // 64 pixelů = přibližně jeden tile.
    //
    // Díky tomu není každý tile samostatná animace.
    // ========================================================

    vec2 p =
        world_position *
        wave_scale;


    // ========================================================
    // ANIMACE
    // ========================================================

    p += vec2(
        TIME * wave_speed * 0.35,
        -TIME * wave_speed * 0.15
    );


    // ========================================================
    // HLAVNÍ VLNKY
    // ========================================================

    float ripple =
        water_ripples(p);


    // Převod na tenké světlé linie
    float lines =
        smoothstep(
            0.42,
            0.72,
            ripple
        );


    // ========================================================
    // DRUHÁ VRSTVA
    // ========================================================
    //
    // Jemnější odlesky, které se pohybují jiným směrem.
    // ========================================================

    vec2 p2 =
        world_position *
        wave_scale *
        1.85;


    p2 += vec2(
        -TIME * wave_speed * 0.22,
        TIME * wave_speed * 0.12
    );


    float ripple2 =
        water_ripples(
            p2
        );


    float lines2 =
        smoothstep(
            0.52,
            0.78,
            ripple2
        );


    // Druhá vrstva je slabší
    lines2 *= 0.35;


    // ========================================================
    // TŘETÍ JEMNÁ VRSTVA
    // ========================================================

    vec2 p3 =
        world_position *
        wave_scale *
        0.55;


    p3 += vec2(
        TIME * wave_speed * 0.08,
        TIME * wave_speed * 0.04
    );


    float ripple3 =
        water_ripples(
            p3
        );


    float lines3 =
        smoothstep(
            0.58,
            0.82,
            ripple3
        );


    lines3 *= 0.20;


    // ========================================================
    // FINÁLNÍ VLNY
    // ========================================================

    float waves =
        lines +
        lines2 +
        lines3;


    // Omezíme maximum
    waves =
        clamp(
            waves,
            0.0,
            1.0
        );


    // ========================================================
    // TYRKYSOVÝ ODLESK
    // ========================================================

    base_color.rgb =
        mix(
            base_color.rgb,
            wave_color.rgb,
            waves * wave_strength
        );


    COLOR =
        base_color;
}