// TEMPLATE FOR PHD REPORTS.

#import "colors.typ": *
#import "common.typ": *
#import "fonts.typ": *
#import "logos.typ": *


// Define an author group.
//
// An author group can be anything, from a very specific single-member group (e.g. "PhD student")
// to a broader multi-member group (e.g. "External committee").
//
// Parameters:
// - group-title: the title of the group.
// - members: the members of the group. The expected type is an array of author dictionaries,
//   containing at least the name of the author, and optionally the organization and the email of
//   the author.
// - size: the size of the authors.
#let _author-group(group-title: none, members: none, size: none) = box[
    #set text(size: size)

    #stack(
        dir: ttb,
        spacing: 8pt,
        [*#group-title*],
        // Put all the members under the same group title.
        stack(
            dir: ltr,
            spacing: 20pt,
            ..for member in members {
                (
                    stack(
                        dir: ttb,
                        spacing: 5pt,
                        member.name,
                        if "organization" in member {
                            member.organization
                        },
                        if "email" in member {
                            link("mailto:" + member.email)
                        },
                    ),
                )
            }
        ),
    )
]


// Define the front page of the report.
//
// The front page is not numbered and contains the title and subtitle of the report, the date, some
// logos and every person that must be mentioned on it (the authors, supervisors, committee
// members, ...).
//
// Parameters:
// - title: the title of the report.
// - title-size: the size of the title.
// - subtitle: the subtitle of the report.
// - subtitle-size: the size of the subtitle.
// - date: the date of the report.
// - date-size: the size of the date.
// - authors: the authors and other people that should be mentioned in the front page. The expected
//   type is an array of rows, where each row can contain one or more groups (with one or more
//   members). See default arguments in `report-setup()`.
// - authors-size: the size of the authors.
// - logos: the logos to put in the front page. The expected type is `image()`, not `str`.
// - logos-size: the size of the logos.
#let _report-front-page(
    title: none,
    title-size: none,
    subtitle: none,
    subtitle-size: none,
    date: none,
    date-size: none,
    authors: (),
    authors-size: none,
    logos: (),
    logos-size: none,
) = block(width: 100%, height: 100%)[
    #set align(center + horizon)

    // Title/subtitle/date block.
    #stack(
        dir: ttb,
        spacing: 15pt,
        text(size: title-size)[*#title*],
        text(size: subtitle-size)[#subtitle],
        text(size: date-size)[#date.display("[day padding:zero]/[month padding:zero]/[year]")],
        stack(
            dir: ltr,
            spacing: 15pt,
            ..for logo in logos {
                (
                    image(logo.path, height: logos-size),
                )
            }
        ),
    )

    #v(2cm)

    // List out the authors.
    #stack(
        dir: ttb,
        spacing: 30pt,
        // There may be multiple rows of authors.
        ..for author-row in authors {
            (
                stack(
                    dir: ltr,
                    spacing: 20pt,
                    // Stack the author groups of a given row horizontally.
                    ..for author-group in author-row {
                        (
                            _author-group(
                                group-title: author-group.group,
                                members: author-group.members,
                                size: authors-size,
                            ),
                        )
                    }
                ),
            )
        }
    )
]


// Define the footer of the report.
//
// Parameters:
// - title: the title of the report.
// - subtitle: the subtitle of the report.
#let _page-footer(title: none, subtitle: none) = block(width: 100%, height: 100%)[
    #set align(horizon)

    #grid(
        columns: (1fr, 50pt),
        [
            #set align(left)
            #set text(weight: "regular", style: "italic")

            #title
            #if subtitle != none [
                --- #subtitle
            ]
        ],
        [
            #set align(right)

            #context counter(page).display("1 / 1", both: true)
        ],
    )
]


// Define the signature page of the report.
//
// Sometimes reports need to be signed, so this function generates a blank signature page.
//
// Parameters:
// - signature: the title of the signature (e.g. "Signature of the thesis supervisor").
#let _signature-page(signature: none) = block(width: 100%, height: 100%)[
    #set align(center + horizon)

    #box[
        #set align(left)

        #stack(
            dir: ttb,
            spacing: 10pt,
            [*#signature*],
            [Name:],
            [Date:],
            [Signature:],
        )
    ]
]


// Set up a report.
//
// This should be called at the very beginning of the report file.
//
// Parameters:
// - title: the title of the report.
// - title-size: the size of the title.
// - subtitle: the subtitle of the report.
// - subtitle-size: the size of the subtitle.
// - date: the date of the report. The expected type is `datetime()`, not `str`.
// - date-size: the size of the date.
// - authors: the authors and other people that need to appear in the front page of the report. For
//   the expected type, see the default value below.
// - authors-size: the size of the authors.
// - logos: the logos to appear on the front page of the report. The expected type is `image()`,
//   not `str`.
// - logos-size: the size of the logos.
// - signature: the title of the signature, if one is needed. If `none`, no signature page will be
//   generated.
// - toc: the table of contents (if `none`, the default one will be used).
// - bibliography: the bibliography to be used in the report.
#let report-setup(
    title: "Report title",
    title-size: 40pt,
    subtitle: "Report subtitle",
    subtitle-size: 25pt,
    date: datetime.today(),
    date-size: 16pt,
    authors: (
        (
            (
                group: "PhD student",
                members: (
                    (
                        name: "Default student",
                        organization: "Default organization",
                        email: "student@email.com"
                    ),
                ),
            ),
        ),
        (
            (
                group: "Supervisor",
                members: (
                    (
                        name: "Default supervisor",
                        organization: "Default organization",
                        email: "supervisor@email.com"
                    ),
                ),
            ),
            (
                group: "Co-supervisor",
                members: (
                    (
                        name: "Default co-supervisor",
                        organization: "Default organization",
                        email: "co-supervisor@email.com"
                    ),
                ),
            ),
        ),
        (
            (
                group: "External committee",
                members: (
                    (
                        name: "Default committee member 1",
                        organization: "Default organization",
                        email: "committee-member1@email.com"
                    ),
                    (
                        name: "Default committee member 2",
                        organization: "Default organization",
                        email: "committee-member2@email.com"
                    ),
                )
            ),
        ),
    ),
    authors-size: 12pt,
    logos: (
        LOGO_CEA_LIST,
        LOGO_UNIVERSITE_PARIS_SACLAY,
        LOGO_IP_PARIS,
    ),
    logos-size: 60pt,
    signature: "Signature of the thesis supervisor",
    toc: none,
    bibliography: none,
    doc,
) = {
    // Main page/font formatting.
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
    
    // Disable numbering for the first few pages.
    set page(numbering: none)

    // Start with the front page.
    _report-front-page(
        title: title,
        title-size: title-size,
        subtitle: subtitle,
        subtitle-size: subtitle-size,
        date: date,
        date-size: date-size,
        authors: authors,
        authors-size: authors-size,
        logos: logos,
        logos-size: logos-size,
    )

    // Add the signature page if needed.
    if signature != none {
        _signature-page(signature: signature)
    }

    // Re-apply numbering from now on, and add the footer.
    set page(
        numbering: "1",
        footer: _page-footer(title: title, subtitle: subtitle),
    )

    // Add the table of contents.
    if toc != none {
        toc
    } else {
        outline()
    }
    pagebreak()

    doc

    // Add the bibliography (if it exists).
    if bibliography != none {
        pagebreak()
        bibliography
    }
}
