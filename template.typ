// TEMPLATE FOR PHD DOCUMENTS AND PRESENTATIONS.

// ========== COLORS ==========
#let CODE_SNIPPET_COLOR = luma(210)
#let MAIN_PRESENTATION_COLOR = rgb("#8a0f1d")
#let BACKGROUND_PRESENTATION_COLOR = luma(240)

// ========== FONTS ==========
#let MAIN_FONT = "Albert Sans"
#let CODE_FONT = "Inconsolata"

// ========== IMAGES ==========
#let CEA_LIST_LOGO = "assets/cea_list_logo.png"
#let UNIVERSITE_PARIS_SACLAY_LOGO = "assets/universite_paris_saclay_logo.png"
#let IP_PARIS_LOGO = "assets/ip_paris_logo.png"

// Use to get an image of logos by using the template's local path. The distinction between paths
// local to the template or local to the document is not currently supported, see
// https://github.com/typst/typst/issues/971.
#let logo_image(logo, width: auto, height: auto) = image(logo, width: width, height: height)


// ========== PLAIN DOCUMENT ==========
// Set up the formatting for the document (font, size, section numbering etc.)
#let doc_setup(doc) = [
    // Main page/font formatting.
    #set page(numbering: "1")
    #set text(
        font: MAIN_FONT,
        size: 11pt
    )
    #set heading(numbering: "1.")
    #set par(justify: true)
    #show link: set text(fill: blue)
    #show link: underline
    #set list(marker: ([•], [--]))
    #set enum(numbering: "1.a.")

    // Formatting for raw blocks; globally, this is just setting a gray background and a nice
    // rounded box.
    #show raw: set text(font: CODE_FONT)
    #show raw.where(block: false): box.with(
        fill: CODE_SNIPPET_COLOR,
        inset: (x: 3pt, y: 0pt),
        outset: (y: 3pt),
        radius: 2pt,
    )
    #show raw.where(block: true): block.with(
        fill: CODE_SNIPPET_COLOR,
        inset: 10pt,
        radius: 4pt,
        width: 100%,
    )

    #doc
]

// Quick access to email address.
#let dimitri_email = link("mailto:dimitri.kokkonis@cea.fr")

// Primary and secondary colors for warning and note boxes.
#let warn_primary_color = rgb(255, 157, 28)
#let warn_secondary_color = warn_primary_color.darken(40%)
#let note_primary_color = rgb(36, 181, 118)
#let note_secondary_color = note_primary_color.darken(40%)

// Setup a message box for warnings, notes etc.
//
// Arguments:
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
// Arguments:
// - message: the message to put in the warning box.
#let warn(message) = message_box(
    warn_primary_color, warn_secondary_color, "!", "Warning", message
)
// Create a note box.
//
// Arguments:
// - message: the message to put in the note box.
#let note(message) = message_box(
    note_primary_color, note_secondary_color, "i", "Note", message
)

// Create a code snippet.
//
// Arguments:
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



// ========== PRESENTATION DOCUMENT ==========
// State configuration for the slides. This needs to be set (not directly!) at the very beginning of
// the presentation.
#let config = state(
    "config",
    (
        title: none,
        title_short: none,
        date: none,
        subtitle: none,
        authors: (),
        authors_short: (),
        logos: (),
        footer_logos: (),
        current_section: none
    )
)
// Counter for numbering the slides.
#let slide_counter = counter("slide_counter")

// Set up a presentation.
// This should be called once at the very beginning of the presentation file.
//
// Arguments:
// - title: the title of the presentation.
// - title_short: a short version of the title that appears in the footer.
// - date: a date to put in the first slide of the presentation (should be provided in actual date
//         form, not string form (e.g. `datetime(year: 2011, month: 8, day: 25)`).
// - subtitle: the subtitle of the presentation.
// - authors: the list of authors of the presentation. The argument should be of the form
//            `((name: _, organization: _, email: _), ...)`.
// - authors_short: a list of shortened names of the authors that appears in the footer (e.g.
//                  `("name", "here", ...)`).
// - logos: a list of file paths to various logos that should be inserted in the first slide of the
//          presentation.
// - footer_logos: a list of file paths to various logos that should be inserted in the footer.
// - doc: the rest of the document (implicit).
#let presentation_setup(
    title: "Presentation title",
    title_short: "Short title",
    date: datetime.today(),
    subtitle: "Subtitle",
    authors: (
        (
            name: "Default author",
            organization: "Default organization",
            email: "default@email.com"
        ),
    ),
    authors_short: (
        "D. Author",
    ),
    logos: (
        CEA_LIST_LOGO,
        UNIVERSITE_PARIS_SACLAY_LOGO,
        IP_PARIS_LOGO,
    ),
    footer_logos: (
        CEA_LIST_LOGO,
        UNIVERSITE_PARIS_SACLAY_LOGO,
        IP_PARIS_LOGO,
    ),
    doc,
) = {
    show: doc_setup
    // Main page/font formatting.
    set page(paper: "presentation-16-9", numbering: "1", number-align: right, margin: 0pt)
    set heading(numbering: none)
    // Set the config for the first time.
    config.update(
        (
            title: title,
            title_short: title_short,
            date: date,
            subtitle: subtitle,
            authors: authors,
            authors_short: authors_short,
            logos: logos,
            footer_logos: footer_logos,
            current_section: none
        )
    )
    doc
}

// Create the slide footer.
//
// Arguments:
// - title: the title of the specific slide to put in the footer (`none` if no title is needed).
// - number: the slide number to put (`none` if no number is needed).
#let slide_footer(title: none, number: none) = [
    // Use locate to get access to the config data at this point.
    #locate(loc => {
        let data = config.at(loc)
        align(bottom)[
            #block(fill: MAIN_PRESENTATION_COLOR, width: 100%)[
                #set text(fill: BACKGROUND_PRESENTATION_COLOR)
                #set align(horizon)

                #grid(
                    columns: if number != none {(2fr, 1fr, 0.1fr)} else {(2fr, 1fr)},
                    column-gutter: 0pt,
                    text[
                        #let logo_height = 25pt

                        #for logo in data.footer_logos [
                            #box(
                                fill: BACKGROUND_PRESENTATION_COLOR,
                                image(logo, height: logo_height)
                            )
                        ]
                        #box(height: logo_height)[
                            #h(0.2cm)
                            #text(style: "italic")[
                                #data.title_short
                                // Only show the section title if we're in a section.
                                #if data.current_section != none [ *|* #data.current_section ]
                                // Only show the title if one is provided.
                                #if title != none [ *|* #title ]
                            ]
                        ]
                    ],
                    text[
                        #for author in data.authors_short [
                            #if not author == data.authors_short.last() [
                                #author,
                            ] else [
                                #author
                            ]
                        ]
                    ],
                    // Only show the slide number if one is provided.
                    if number != none { text[#number] }
                )
            ]
        ]
    })
]

// Create the title slide.
// This slide acts as a sort of "front page" of the presentation, presenting the title, authors,
// date etc.
#let title_slide(title_size: 40pt, subtitle_size: 20pt, date_size: 15pt) = {
    locate(loc => {
        let data = config.at(loc)
        block(fill: BACKGROUND_PRESENTATION_COLOR, width: 100%, height: 100%)[
            #align(center + horizon)[
                #block(height: 70%, width: 80%)[
                    #set par(justify: false)

                    #block[
                        #text(
                            size: title_size,
                            fill: MAIN_PRESENTATION_COLOR,
                            bottom-edge: "descender"
                        )[#data.title] \
                        #text(
                            size: subtitle_size,
                            bottom-edge: "descender"
                        )[#data.subtitle] \
                        #text(size: date_size)[
                            #data.date.display("[day]/[month]/[year]")
                        ]
                    ]

                    #block(above: 1cm, below: 1cm)[
                        #grid(
                            gutter: 10pt,
                            columns: (1fr,) * data.authors.len(),
                            ..for author in data.authors {
                                (
                                    text[
                                        #author.name \
                                        #if "organization" in author [
                                            #author.organization \
                                        ]
                                        #if "email" in author [
                                            #link("mailto:" + author.email)
                                        ]
                                    ],
                                )
                            }
                        )
                    ]

                    #if data.logos != none {
                        block[
                            #for logo in data.logos {
                                box(image(logo, height: 40pt))
                                if logo != data.logos.last() {
                                    h(1cm)
                                }
                            }
                        ]
                    }
                ]
            ]
            
            #slide_footer()
        ]
    })
}


// Create a slide.
//
// Arguments:
// - title: the title of the slide.
// - size: the font size for the slide.
// - body: the body of the slide.
#let slide(title: none, size: 20pt, body) = [
    // Increment the slide counter.
    #slide_counter.step()
    #locate(loc => {
        let data = config.at(loc)
        block(fill: BACKGROUND_PRESENTATION_COLOR, width: 100%, height: 100%)[
            #block(fill: MAIN_PRESENTATION_COLOR.darken(5%), width: 100%, inset: 15pt)[
                #if data.current_section == none [
                    #text(size: 40pt, fill: BACKGROUND_PRESENTATION_COLOR)[#title]
                ] else [
                    #set align(bottom)
                    #grid(
                        columns: (5fr, 1fr),
                        text(size: 40pt, fill: BACKGROUND_PRESENTATION_COLOR)[#title],
                        text(size: 15pt, fill: BACKGROUND_PRESENTATION_COLOR)[
                            #set align(right)
                            #set par(justify: false)
                            #data.current_section
                        ]
                    )
                ]
            ]

            #block(inset: 20pt, width: 100%)[
                #text(size: size)[#body]
            ]

            #slide_footer(title: title, number: slide_counter.display())
        ]
    })
]


// Create a section slide.
// This slide introduces a new section with a title and subtitle; contrary to normal slides, it does
// not have a body.
//
// Arguments:
// - title: the section title.
// - subtitle: the section subtitle.
#let section_slide(title: none, subtitle: none) = [
    #slide_counter.step()
    #config.update(
        data => (
            title: data.title,
            title_short: data.title_short,
            date: data.date,
            subtitle: data.subtitle,
            authors: data.authors,
            authors_short: data.authors_short,
            logos: data.logos,
            footer_logos: data.footer_logos,
            current_section: title
        )
    )

    #block(fill: MAIN_PRESENTATION_COLOR, width: 100%, height: 100%)[
        #set align(center + horizon)

        #text(size: 40pt, fill: BACKGROUND_PRESENTATION_COLOR)[#strong[#title]]

        #text(size: 20pt, fill: BACKGROUND_PRESENTATION_COLOR)[#subtitle]
    ]
]
