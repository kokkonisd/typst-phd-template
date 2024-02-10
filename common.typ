// ========== COLORS ==========
#let CODE_SNIPPET_COLOR = luma(210)
#let _WARN_PRIMARY_COLOR = rgb(255, 157, 28)
#let _WARN_SECONDARY_COLOR = _WARN_PRIMARY_COLOR.darken(40%)
#let _NOTE_PRIMARY_COLOR = rgb(36, 181, 118)
#let _NOTE_SECONDARY_COLOR = _NOTE_PRIMARY_COLOR.darken(40%)

// ========== FONTS ==========
#let MAIN_FONT = "Albert Sans"
#let CODE_FONT = "Inconsolata"

// ========== IMAGES ==========
#let LOGO_CEA_LIST = image("/assets/cea_list_logo.png")
#let LOGO_UNIVERSITE_PARIS_SACLAY = image("/assets/universite_paris_saclay_logo.png")
#let LOGO_IP_PARIS = image("/assets/ip_paris_logo.png")


// A common setup function to use for each sub-template.
//
// Parameters:
// - doc: the document to apply the setup to.
#let _common_setup(doc) = {
    set page(numbering: "1")
    set text(
        font: MAIN_FONT,
        size: 11pt
    )
    set heading(numbering: "1.")
    set par(justify: true)
    show link: set text(fill: blue)
    show link: underline
    set list(marker: ([•], [--]))
    set enum(numbering: "1.a.")

    // Formatting for raw blocks; this is just setting a gray background and a nice rounded box.
    show raw: set text(font: CODE_FONT)
    show raw.where(block: false): box.with(
        fill: CODE_SNIPPET_COLOR,
        inset: (x: 3pt, y: 0pt),
        outset: (y: 3pt),
        radius: 2pt,
    )
    show raw.where(block: true): block.with(
        fill: CODE_SNIPPET_COLOR,
        inset: 10pt,
        radius: 4pt,
        width: 100%,
    )

    doc
}


// Primary and secondary colors for warning and note boxes.


// Setup a message box for warnings, notes etc.
//
// Parameters:
// - primary_color: the primary color of the box.
// - secondary_color: the secondary color of the box.
// - icon: the icon used in the box (single character).
// - title: the title of the box.
// - message: the message displayed in the box.
#let message_box(primary_color, secondary_color, icon, title, message) = block(
    radius: 4pt,
    fill: primary_color,
    breakable: false,
)[
    #set text(fill: white)
    #show raw: set text(fill: black)

    #block(
        radius: (top: 4pt),
        fill: secondary_color,
        inset: (left: 10pt, right: 10pt, y: 4pt),
        width: 100%
    )[
        #box[
            #set align(center + horizon)
            #box[
                #circle(fill: primary_color, inset: 0.5pt)[
                    #text(fill: secondary_color)[#strong[#icon]]
                ]
            ]
            #box(inset: 2pt)[#emph[#title]]
        ]
    ]
    #block(inset: 10pt, above: 0pt)[
        #message
    ]
]


// Create a warning box.
//
// Parameters:
// - message: the message to put in the warning box.
#let warn(message) = message_box(
    _WARN_PRIMARY_COLOR, _WARN_SECONDARY_COLOR, "!", "Warning", message
)


// Create a note box.
//
// Parameters:
// - message: the message to put in the note box.
#let note(message) = message_box(
    _NOTE_PRIMARY_COLOR, _NOTE_SECONDARY_COLOR, "i", "Note", message
)


// Create a code snippet.
//
// Parameters:
// - source: the raw source of the snippet.
// - file: the file (or title, context etc) of the snippet.
#let code(source, file: none) = block(breakable: false)[
    #block(radius: (top: 4pt), inset: (x: 10pt, y: 4pt), below: 0pt, fill: luma(50))[
        #text(font: CODE_FONT, fill: white, size: 0.7em)[#emph[#file]]
    ]
    #block(
        radius: (bottom: 4pt, top-right: 4pt),
        inset: 10pt,
        fill: CODE_SNIPPET_COLOR,
        width: 100%
    )[
      #raw(source.text, lang: source.at("lang", default: none))
    ]
]
