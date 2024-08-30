#import "colors.typ": *
#import "fonts.typ": *
#import "logos.typ": *


// Get the title of the current slide.
//
// The title of the current slide will be fetched through metadata tags, if it exists.
// See the beginning of the `slide()` function.
//
// Parameters:
// - loc: the location to get the current slide for.
// - in-header: if `true`, make the function behave as if it were called inside a header (before
//   the slide is named); otherwise, it'll behave as if it were called in the body or the footer
//   (after the slide is named).
#let _current-slide(loc, in-header: false) = {
    if in-header {
        // The header is defined before the title of the slide; for that reason, we need to look
        // for the first slide title definition after the current location.
        query(selector(<slide-title>).after(loc, inclusive: true)).first().value
    } else {
        // We're either in the body or the footer, so the title of the slide is defined before this
        // location; this is why we need to look backwards.
        query(selector(<slide-title>).before(loc, inclusive: true)).last().value
    }
}


// Get the title of the current section of the presentation.
//
// The title of the current section will be fetched through metadata tags, if it exists.
// See the beginning of the `section-slide()` function.
//
// Parameters:
// - loc: the location to get the current section for.
#let _current-section(loc) = {
    // Since the section slides themselves do not have a header, we need to always look back to get
    // the last section name.
    query(selector(<section-title>).before(loc)).last().value
}


// Define the header of the slides.
#let _slide-header = block(width: 100%, height: 100%, fill: MAIN_COLOR, inset: 10pt)[
    #set text(fill: SECONDARY_COLOR)

    #grid(
        columns: (2fr, 1fr),
        box(width: 100%, height: 100%)[
            #set align(left + horizon)

            // Get the slide title for the current slide.
            #context {
                text(_current-slide(here(), in-header: true), size: 30pt)
            }
        ],
        box(width: 100%, height: 100%)[
            #set align(right + horizon)

            // Get the section title for the current slide (if it exists, otherwise it'll be empty).
            #context {
                _current-section(here())
            }
        ],
    )
]


// Define the footer of the slides.
//
// Parameters:
// - title: the (short) title of the presentation, to be shown in the footer.
// - authors: the array of short author names (`array[str]`) to be shown in the footer.
// - logos: the array of logo images (`array[image()]`) to be shown in the footer.
#let _slide-footer(title: none, authors: (), logos: ()) = block(
    width: 100%,
    height: 100%,
    fill: MAIN_COLOR
)[
    #set text(fill: SECONDARY_COLOR)

    #grid(
        columns: (2fr, 1fr),
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
                            box(fill: SECONDARY_COLOR)[
                                #image(logo.path, height: 100%)
                            ],
                        )
                    }
                ),
                text(style: "italic")[
                    #title
                    #context {
                        if _current-section(here()) != none [
                            *•* #_current-section(here())
                        ]
                        if _current-slide(here()) != none [
                            *•* #_current-slide(here())
                        ]
                    }
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
                    #context counter(page).display()
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
// - title-size: the size of the title.
// - subtitle: the subtitle of the presentation.
// - subtitle-size: the size of the subtitle.
// - cover-image: an image to use as the cover of the title page.
// - date: the date of the presentation. The expected type is `datetime()`, not `str..
// - date-size: the size of the date.
// - authors: the authors of the presentation. For the expected type, see the defaults in
//   `presentation-setup()`.
// - authors-size: the size of the authors,
// - logos: the logos of the presentation.
// - logos-size: the size of the logos.
#let _title-slide(
    title: none,
    title-size: none,
    subtitle: none,
    subtitle-size: none,
    cover-image: none,
    date: none,
    date-size: none,
    authors: (),
    authors-size: none,
    logos: (),
    logos-size: none,
) = block(width: 100%, height: 100%, fill: SECONDARY_COLOR)[
    #set align(center + horizon)

    // Title block.
    #stack(
        dir: ttb,
        spacing: 15pt,
        text(size: title-size, fill: MAIN_COLOR)[#title],
        text(size: subtitle-size)[#subtitle],
        if cover-image != none { cover-image },
        text(size: date-size)[#date.display()],
    )

    #v(20pt)

    // Authors.
    #box[
        #set text(size: authors-size)

        #stack(
            dir: ltr,
            spacing: 20pt,
            ..for author in authors {
                (
                    stack(
                        dir: ttb,
                        spacing: 4pt,
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
                image(logo.path, height: logos-size),
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
    fill: SECONDARY_COLOR,
)[
    #metadata(title) <slide-title>
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
// - title-size: the size of the title.
// - subtitle: the subtitle of the section (optional).
// - subtitle-size: the size of the subtitle.
#let section-slide(
    title: "Section title",
    title-size: 40pt,
    subtitle: none,
    subtitle-size: 30pt
) = {
    set page(numbering: none, header: none, footer: none, margin: 0pt)

    block(width: 100%, height: 100%, fill: MAIN_COLOR)[
        #metadata(title) <section-title>
        #set text(fill: SECONDARY_COLOR)
        #set align(center + horizon)

        #text(size: title-size)[*#title*]

        #text(size: subtitle-size)[#subtitle]
    ]
}


// Set up a presentation.
//
// This should be called once at the very beginning of the presentation file.
//
// Parameters:
// - title: the title of the presentation.
// - title-size: the size of the title.
// - title-short: a short version of the title that appears in the footer.
// - subtitle: the subtitle of the presentation.
// - subtitle-size: the size of the subtitle.
// - cover-image: an image to put as a cover on the title page.
// - date: a date to put in the first slide of the presentation (should be provided in actual date
//   form, not string form (e.g. `datetime(year: 2011, month: 8, day: 25)`).
// - date-size: the size of the date.
// - authors: the list of authors of the presentation. The argument should be of the form
//   `((name: _, organization: _, email: _), ...)`.
// - authors-size: the size of the authors.
// - authors-short: a list of shortened names of the authors that appears in the footer (e.g.
//   `("name", "here", ...)`).
// - logos: a list of logos that should be inserted in the first slide of the presentation. The
//   expected type is `image()`, not `str`.
// - footer-logos: a list of logos that should be inserted in the footer. The expected type is
//   `image()`, not `str`.
// - doc: the rest of the document (implicit).
#let presentation-setup(
    title: "Presentation title",
    title-size: 40pt,
    title-short: "Short title",
    subtitle: "Subtitle",
    subtitle-size: 25pt,
    cover-image: none,
    date: datetime.today(),
    date-size: 16pt,
    authors: (
        (
            name: "Default author",
            organization: "Default organization",
            email: "default@email.com"
        ),
    ),
    authors-size: 14pt,
    authors-short: (
        "D. Author",
    ),
    logos: (
        LOGO_CEA_LIST,
        LOGO_UNIVERSITE_PARIS_SACLAY,
        LOGO_IP_PARIS,
    ),
    logos-size: 40pt,
    footer-logos: (
        LOGO_CEA_LIST,
        LOGO_UNIVERSITE_PARIS_SACLAY,
        LOGO_IP_PARIS,
    ),
    header-height: 45pt,
    footer-height: 20pt,
    doc,
) = {
    // Main page/font formatting.
    set page(
        paper: "presentation-16-9",
        numbering: none,
        number-align: bottom,
        margin: 0pt,
    )
    set par(justify: false)
    set heading(numbering: none)
    set text(font: MAIN_FONT)

    // Lists.
    set list(marker: ([•], [--]))
    set enum(numbering: "1.a.")

    // Links.
    show link: set text(fill: blue)
    show link: underline

    // Raw/code blocks.
    show raw: set text(font: CODE_FONT)

    _title-slide(
        title: title,
        title-size: title-size,
        subtitle: subtitle,
        subtitle-size: subtitle-size,
        cover-image: cover-image,
        date: date,
        date-size: date-size,
        authors: authors,
        authors-size: authors-size,
        logos: logos,
        logos-size: logos-size,
    )

    // Set the slide & section titles for the first time (to none, since there aren't any yet).
    [
        #metadata(none) <slide-title>
        #metadata(none) <section-title>
    ]

    // Reset the page counter after the title slide.
    counter(page).update(0)
    set page(
        numbering: "1",
        margin: (x: 0pt, top: header-height, bottom: footer-height),
        header: _slide-header,
        header-ascent: 0%,
        footer: _slide-footer(title: title-short, authors: authors-short, logos: footer-logos),
        footer-descent: 0%,
    )

    doc
}
