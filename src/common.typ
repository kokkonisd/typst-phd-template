#import "colors.typ": *
#import "fonts.typ": *


// Setup a message box for warnings, notes etc.
//
// Parameters:
// - primary-color: the primary color of the box.
// - secondary-color: the secondary color of the box.
// - icon: the icon used in the box (single character).
// - title: the title of the box.
// - message: the message displayed in the box.
// - width: the width of the box.
#let message-box(primary-color, secondary-color, icon, title, message, width: 100%) = block(
    radius: 4pt,
    fill: primary-color,
    breakable: false,
)[
    #set text(fill: white)
    #show raw: set text(fill: black)

    #block(
        radius: (top: 4pt),
        fill: secondary-color,
        inset: (x: 10pt, y: 4pt),
        width: width,
    )[
        #set align(left)
        #box[
            #set align(center + horizon)
            #box[
                #circle(fill: primary-color, inset: 0.5pt)[
                    #text(fill: secondary-color)[#strong[#icon]]
                ]
            ]
            #box(inset: 3pt)[#emph[#title]]
        ]
    ]
    #block(inset: 10pt, above: 0pt, width: width)[
        #message
    ]
]


// Create a warning box.
//
// Parameters:
// - message: the message to put in the warning box.
// - width: the width of the warning box.
#let warn(message, width: 100%) = message-box(
    WARN_PRIMARY_COLOR, WARN_SECONDARY_COLOR, "!", "Warning", message, width: width
)


// Create a note box.
//
// Parameters:
// - message: the message to put in the note box.
// - width: the width of the warning box.
#let note(message, width: 100%) = message-box(
    NOTE_PRIMARY_COLOR, NOTE_SECONDARY_COLOR, "i", "Note", message, width: width
)


// Create a code snippet.
//
// Parameters:
// - source: the raw source of the snippet.
// - file: the file (or title, context etc) of the snippet.
#let code(source, file: none) = block(breakable: false)[
    #if file != none [
        #block(
            radius: (top: 4pt),
            inset: (x: 10pt, y: 4pt),
            below: 0pt,
            fill: MAIN_COLOR,
        )[
            #text(
                fill: CODE_SNIPPET_COLOR,
                size: 0.7em
            )[
                #emph[#file]
            ]
        ]
    ]
    #block(
        radius: (
            bottom: 4pt,
            top-right: 4pt,
            top-left: if file != none { 0pt } else { 4pt },
        ),
        inset: 10pt,
        fill: CODE_SNIPPET_COLOR,
        width: 100%
    )[
      #raw(source.text, lang: source.at("lang", default: none))
    ]
]
