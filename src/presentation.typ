// TEMPLATE FOR PHD PRESENTATIONS.

#import "common.typ": *


// ========== COLORS ==========
#let PRESENTATION_MAIN_COLOR = rgb("#8a0f1d")
#let PRESENTATION_BACKGROUND_COLOR = luma(240)


// Get the title of the current slide.
//
// The title of the current slide will be fetched through metadata tags, if it exists.
// See the beginning of the `slide()` function.
//
// Parameters:
// - loc: the location to get the current slide for.
// - in_header: if `true`, make the function behave as if it were called inside a header (before
//   the slide is named); otherwise, it'll behave as if it were called in the body or the footer
//   (after the slide is named).
#let _current_slide(loc, in_header: false) = {
    if in_header {
        // The header is defined before the title of the slide; for that reason, we need to look
        // for the first slide title definition after the current location.
        query(selector(<slide_title>).after(loc, inclusive: true), loc).first().value
    } else {
        // We're either in the body or the footer, so the title of the slide is defined before this
        // location; this is why we need to look backwards.
        query(selector(<slide_title>).before(loc, inclusive: true), loc).last().value
    }
}


// Get the title of the current section of the presentation.
//
// The title of the current section will be fetched through metadata tags, if it exists.
// See the beginning of the `section_slide()` function.
//
// Parameters:
// - loc: the location to get the current section for.
#let _current_section(loc) = {
    // Since the section slides themselves do not have a header, we need to always look back to get
    // the last section name.
    query(selector(<section_title>).before(loc), loc).last().value
}


// Define the header of the slides.
#let _slide_header = block(width: 100%, height: 100%, fill: PRESENTATION_MAIN_COLOR, inset: 10pt)[
    #set text(fill: PRESENTATION_BACKGROUND_COLOR)

    #grid(
        columns: (auto, auto),
        box(width: 100%, height: 100%)[
            #set align(left + horizon)

            // Get the slide title for the current slide.
            #locate(loc => text(_current_slide(loc, in_header: true), size: 30pt))
        ],
        box(width: 100%, height: 100%)[
            #set align(right + horizon)

            // Get the section title for the current slide (if it exists, otherwise it'll be empty).
            #locate(loc => _current_section(loc))
        ],
    )
]


// Define the footer of the slides.
//
// Parameters:
// - title: the (short) title of the presentation, to be shown in the footer.
// - authors: the array of short author names (`array[str]`) to be shown in the footer.
// - logos: the array of logo images (`array[image()]`) to be shown in the footer.
#let _slide_footer(title: none, authors: (), logos: ()) = block(
    width: 100%,
    height: 100%,
    fill: PRESENTATION_MAIN_COLOR
)[
    #set text(fill: PRESENTATION_BACKGROUND_COLOR)

    #grid(
        columns: (auto, auto),
        box(width: 100%, height: 100%)[
            #set align(left + horizon)

            #stack(
                dir: ltr,
                spacing: 12pt,
                stack(
                    dir: ltr,
                    spacing: 2pt,
                    ..for logo in logos {
                        (
                            box(fill: PRESENTATION_BACKGROUND_COLOR)[
                                #image(logo.path, height: 100%)
                            ],
                        )
                    }
                ),
                text(style: "italic")[
                    #title
                    #locate(loc => {
                        if _current_section(loc) != none [
                            *|* #_current_section(loc)
                        ]
                        if _current_slide(loc) != none [
                            *|* #_current_slide(loc)
                        ]
                    })
                ],
            )
        ],
        box(width: 100%, height: 100%, inset: (right: 20pt))[
            #set align(right + horizon)

            #grid(
                columns: (auto, 30pt),
                gutter: 50pt,
                [
                    #for author in authors {
                        if not author == authors.last() [
                            #author,
                        ] else [
                            #author
                        ]
                    }
                ],
                [
                    #counter(page).display()
                ],
            )
        ],
    )
]


// Define the title slide of the presentation.
//
// The title slide contains the main title, subtitle, date, authors and logos.
//
// Parameters:
// - title: the title of the presentation.
// - title_size: the size of the title.
// - subtitle: the subtitle of the presentation.
// - subtitle_size: the size of the subtitle.
// - date: the date of the presentation. The expected type is `datetime()`, not `str..
// - date_size: the size of the date.
// - authors: the authors of the presentation. For the expected type, see the defaults in
//   `presentation_setup()`.
// - authors_size: the size of the authors,
// - logos: the logos of the presentation.
// - logos_size: the size of the logos.
#let _title_slide(
    title: none,
    title_size: none,
    subtitle: none,
    subtitle_size: none,
    date: none,
    date_size: none,
    authors: (),
    authors_size: none,
    logos: (),
    logos_size: none,
) = block(width: 100%, height: 100%, fill: PRESENTATION_BACKGROUND_COLOR)[
    #set align(center + horizon)

    // Title block.
    #stack(
        dir: ttb,
        spacing: 15pt,
        text(fill: PRESENTATION_MAIN_COLOR, size: title_size)[#title],
        text(size: subtitle_size)[#subtitle],
        text(size: date_size)[#date.display()],
    )

    #v(20pt)

    // Authors.
    #box[
        #set text(size: authors_size)

        #stack(
            dir: ltr,
            spacing: 20pt,
            ..for author in authors {
                (
                    stack(
                        dir: ttb,
                        spacing: 10pt,
                        author.name,
                        if "organization" in author { author.organization },
                        if "email" in author { link("mailto:" + author.email) },
                    ),
                )
            }
        )
    ]

    #v(20pt)

    // Logos.
    #stack(
        dir: ltr,
        spacing: 20pt,
        ..for logo in logos {
            (
                image(logo.path, height: logos_size),
            )
        }
    )
]


// Create a slide.
//
// This is a normal slide, with a title and content.
//
// Parameters:
// - title: the title of the slide.
// - size: the size of the text of the body of the slide.
// - inset: the amount of inset for the body of the slide.
#let slide(body, title: "Slide title", size: 20pt, inset: 20pt) = block(
    width: 100%,
    height: 100%,
    inset: inset,
    fill: PRESENTATION_BACKGROUND_COLOR,
)[
    #metadata(title) <slide_title>
    #set par(justify: true)
    #set text(size: size)

    #body
]


// Create a section slide.
//
// This special slide is used to indicate the beginning of a section; it will display the title of
// the section and optionally a subtitle below it.
//
// Parameters:
// - title: the title of the section.
// - title_size: the size of the title.
// - subtitle: the subtitle of the section (optional).
// - subtitle_size: the size of the subtitle.
#let section_slide(
    title: "Section title",
    title_size: 40pt,
    subtitle: none,
    subtitle_size: 30pt
) = {
    set page(numbering: none, header: none, footer: none, margin: 0pt)

    block(width: 100%, height: 100%, fill: PRESENTATION_MAIN_COLOR)[
        #metadata(title) <section_title>
        #set text(fill: PRESENTATION_BACKGROUND_COLOR)
        #set align(center + horizon)

        #text(size: title_size)[*#title*]

        #text(size: subtitle_size)[#subtitle]
    ]
}


// Set up a presentation.
//
// This should be called once at the very beginning of the presentation file.
//
// Parameters:
// - title: the title of the presentation.
// - title_size: the size of the title.
// - title_short: a short version of the title that appears in the footer.
// - subtitle: the subtitle of the presentation.
// - subtitle_size: the size of the subtitle.
// - date: a date to put in the first slide of the presentation (should be provided in actual date
//   form, not string form (e.g. `datetime(year: 2011, month: 8, day: 25)`).
// - date_size: the size of the date.
// - authors: the list of authors of the presentation. The argument should be of the form
//   `((name: _, organization: _, email: _), ...)`.
// - authors_size: the size of the authors.
// - authors_short: a list of shortened names of the authors that appears in the footer (e.g.
//   `("name", "here", ...)`).
// - logos: a list of logos that should be inserted in the first slide of the presentation. The
//   expected type is `image()`, not `str`.
// - footer_logos: a list of logos that should be inserted in the footer. The expected type is
//   `image()`, not `str`.
// - doc: the rest of the document (implicit).
#let presentation_setup(
    title: "Presentation title",
    title_size: 40pt,
    title_short: "Short title",
    subtitle: "Subtitle",
    subtitle_size: 25pt,
    date: datetime.today(),
    date_size: 16pt,
    authors: (
        (
            name: "Default author",
            organization: "Default organization",
            email: "default@email.com"
        ),
    ),
    authors_size: 14pt,
    authors_short: (
        "D. Author",
    ),
    logos: (
        LOGO_CEA_LIST,
        LOGO_UNIVERSITE_PARIS_SACLAY,
        LOGO_IP_PARIS,
    ),
    logos_size: 40pt,
    footer_logos: ( LOGO_CEA_LIST,
        LOGO_UNIVERSITE_PARIS_SACLAY,
        LOGO_IP_PARIS,
    ),
    header_height: 45pt,
    footer_height: 20pt,
    doc,
) = {
    // Main page/font formatting.
    show: _common_setup
    set page(
        paper: "presentation-16-9",
        numbering: none,
        number-align: bottom,
        margin: (x: 0pt, top: header_height, bottom: footer_height),
    )
    set par(justify: false)
    set heading(numbering: none)

    _title_slide(
        title: title,
        title_size: title_size,
        subtitle: subtitle,
        subtitle_size: subtitle_size,
        date: date,
        date_size: date_size,
        authors: authors,
        authors_size: authors_size,
        logos: logos,
        logos_size: logos_size,
    )

    // Set the slide & section titles for the first time (to none, since there aren't any yet).
    [
        #metadata(none) <slide_title>
        #metadata(none) <section_title>
    ]

    // Reset the page counter after the title slide.
    counter(page).update(0)
    set page(
        numbering: "1",
        header: _slide_header,
        header-ascent: 0%,
        footer: _slide_footer(title: title_short, authors: authors_short, logos: footer_logos),
        footer-descent: 0%,
    )

    doc
}
